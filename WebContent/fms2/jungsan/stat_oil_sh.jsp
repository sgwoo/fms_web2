<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.common.*" %>
<%@ page import="acar.user_mng.*" %>

<%@ include file="/acar/cookies.jsp" %>
<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	BranchBean br_r [] = umd.getBranchAll();
%>
<%
		
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3"); //����
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4"); //��Ʈ
	String gubun5 = request.getParameter("gubun5")==null?"1":request.getParameter("gubun5"); //�Ϲݽ�
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page"); //	
	
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");//Ÿ��
		
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1"); //�Ⱓ
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2"); //
	
	String bm = request.getParameter("bm")==null?"1":request.getParameter("bm");//Ÿ��
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	Vector users = c_db.getUserList("", "", "EMP"); //��������� ����Ʈ
	int user_size = users.size();
	Vector users2 = c_db.getUserList("9999", "", "", "N"); //����� ����Ʈ
	int user_size2 = users2.size();

	int cnt = 3; //��Ȳ ��� �Ѽ�
	int sh_height = cnt*sh_line_height;
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function SearchBrCond()
{
	var theForm = document.SearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
//-->
</script>
</head>
<body leftmargin=15>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > �����Ļ��� > <span class=style5>��������Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="./stat_oil_sc.jsp" name="SearchForm" method="POST" target="c_foot">
	  <input type='hidden' name="s_width" value="<%=s_width%>">   
	  <input type='hidden' name="s_height" value="<%=s_height%>">     
	  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
	
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
         <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
            	<tr>            		
            		<td width=8% class=title>�ŷ���
            		</td>
            		<td colspan=5>&nbsp;<input type="text" name="ref_dt1" size="10" value="<%=ref_dt1%>" class=text> ~ <input type="text" name="ref_dt2" size="10" value="<%=ref_dt2%>" class=text>
					<a href="javascript:SearchBrCond()"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
            	</tr>
            	
            	<tr>
            	  <td width=8% class=title>�����</td>
            	  <td id='td_user' align='left' <%if(gubun3.equals("")){%> style='display:none'<%}%>>&nbsp; 
				        <select name='gubun4' onChange='javascript:SearchRentCond()'>
								<option value="">������</option>
								<%	if(user_size > 0){
										for (int i = 0 ; i < user_size ; i++){
											Hashtable user = (Hashtable)users.elementAt(i);	%>
				                <option value='<%=user.get("USER_ID")%>' <%if(gubun4.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
				                <%		}
									}		%>
						  <option value="">=�����=</option>
				          <%if(user_size2 > 0){
								for (int i = 0 ; i < user_size2 ; i++){
									Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
				          <option value='<%=user2.get("USER_ID")%>' <%if(gubun4.equals(user2.get("USER_ID"))) out.println("selected");%>><%=user2.get("USER_NM")%></option>
				          <%	}
							}%>
				
						</select>
				        &nbsp;&nbsp;</td>      		  
        		  
                  <td width=8% class=title>�뵵����</td>
                  <td width="30%">&nbsp;
        		    <select name='gubun3'>
                      <option value=''  <%if(gubun3.equals("")){ %>selected<%}%>>��ü </option>
                      <option value='11' <%if(gubun3.equals("11")){%>selected<%}%>>�������� </option>
                      <option value='12' <%if(gubun3.equals("12")){%>selected<%}%>>�������� </option>
                      <option value='13' <%if(gubun3.equals("13")){%>selected<%}%>>������ </option>
                    
                    </select>
        		  </td>
                 
                </tr>                
                
            </table>
        </td>
    </tr>
</form>
</table>
</body>
</html>