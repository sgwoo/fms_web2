package acar.client;

public class ClientUserBean
{
	private String user_id;
	private String user_psd;
	private String client_id;
	
	public ClientUserBean()
	{
		user_id = "";
		user_psd = "";
		client_id = "";
	}
	
	public void setUser_id(String str)	{	user_id = str;	}
	public void setUser_psd(String str)	{	user_psd = str;	}
	public void setClient_id(String str){	client_id= str;	}
	
	public String getUser_id()	{	return user_id;		}
	public String getUser_psd()	{	return user_psd;	}
	public String getClient_id(){	return client_id;	}
}