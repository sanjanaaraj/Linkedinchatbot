from fastapi import FastAPI
from typing import Optional
from pydantic import BaseModel,Field
from fastapi.responses import JSONResponse,PlainTextResponse
app=FastAPI()
class connectiondetails(BaseModel):
    user:str
    password:str
    
#optional model if we want to post a reply instead of get
class response(BaseModel):
    reply:str

import os
os.environ['OPENAI_API_KEY']="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"#add ur openapi key from your account
from langchain.chat_models import ChatOpenAI
from langchain.sql_database import SQLDatabase
from langchain_experimental.sql import SQLDatabaseChain
from langchain.agents.agent_toolkits import SQLDatabaseToolkit

from langchain.prompts.prompt import PromptTemplate
from langchain.agents import initialize_agent,Tool,AgentType
import pymysql
#os.environ['ZAPIER_NLA_API_KEY']="*****************" #generate and add your api key from zapier
#from langchain.agents.agent_toolkits import ZapierToolkit
#from langchain.utilities.zapier import ZapierNLAWrapper

llm=ChatOpenAI(temperature=0,model='gpt-3.5-turbo')

_DEFAULT_TEMPLATE="""Given an input question, first create a syntactically correct {dialect} query to run, then look at the results of the query and return the answer.
Use the following format:

Question: "Question here"
SQLQuery: "SQL Query to run"
SQLResult: "Result of the SQLQuery"
Answer: "Final answer here"

Only use the following tables:

{table_info}

if query doesnt provide results, use LIKE to execute.
do mathematical calculations if required.
    

Question: {input}"""
    
PROMPT = PromptTemplate(input_variables=['dialect', 'input','table_info'], template=_DEFAULT_TEMPLATE) 

            

    
#zapier = ZapierNLAWrapper()
#toolkit = ZapierToolkit.from_zapier_nla_wrapper(zapier)
#agent = initialize_agent(toolkit.get_tools(), llm, agent="zero-shot-react-description", verbose=False)





async def connectToDB(user, password, database):
    host ="localhost"
    port =3306  # Default MySQL port
    #print(user)
    #print(password)
    #print(database)
    connection_string = f"mysql+pymysql://{user}:{password}@{host}:{port}/{database}"
    db=SQLDatabase.from_uri(connection_string)
    global db_chain
    db_chain = SQLDatabaseChain.from_llm(llm=llm, db = db,prompt=PROMPT,use_query_checker=True,verbose=True)
    return db_chain

    # Create a connection string for SQLAlchemy

async def gettingresponse(query)->response:
    x=db_chain.run(query)
    return response(reply=x)


@app.get('/connecting')
async def toConnect(user:str, password:str, dbname:str):
    dbchain = await connectToDB(user, password, dbname)
    if dbchain:
        print('connected')
    return dbchain




#end-routes


@app.get('/queries',response_model=response)
async def final(query:str):
    x=await gettingresponse(query)
    return x
    