<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String user_st 	= request.getParameter("user_st")==null?"":request.getParameter("user_st");
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;
	
	String vid_num		= "";
	String doc_no 	= "";
		
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function save(){
		var fm = document.form1;
		
		if(fm.cng_id.value == "")	{ 	alert("����ڸ� �Է��Ͻʽÿ�."); 		return;	}		
		
		if(confirm('�����Ͻðڽ��ϱ�?')){		
			fm.action='doc_user_all_cng_a.jsp';
			fm.target='i_no';
			fm.submit();
		}		
	}

//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>    
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>    
  <input type='hidden' name='start_dt' 	value='<%=start_dt%>'>    
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>          
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='user_st' 	value='<%=user_st%>'>
  <%for(int i=0;i < vid_size;i++){
					vid_num = vid[i];
	%>
  <input type='hidden' name='ch_cd' 	value='<%=vid_num%>'>
  <%}%>
  
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
	    <td align='left'>
	   		<table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ó���� > <span class=style5>������ �ϰ�����</span></span></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
	    </td>
    </tr>  
    <tr>
      <td class=h></td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
        	<tr>
        		<td width='20%' class='title'>���ðǼ�</td> 
        		<td>&nbsp;
                    <%=vid_size%>��
        		</td>
        	</tr>        	
        	<tr>
        		<td class='title'>����</td> 
        		<td>&nbsp;
                    <%if(user_st.equals("user_id2")){%>������2<%}%>
                    <%if(user_st.equals("user_id3")){%>������3<%}%>
                    <%if(user_st.equals("user_id4")){%>������4<%}%>
                    <%if(user_st.equals("user_id5")){%>������5<%}%>
                    <%if(user_st.equals("user_id6")){%>������6<%}%>
                    <%if(user_st.equals("user_id7")){%>������7<%}%>
                    <%if(user_st.equals("user_id8")){%>������8<%}%>
                    <%if(user_st.equals("user_id9")){%>������9<%}%>
        		</td>
        	</tr>
		      <tr>
            <td class='title'>������</td>
            <td>&nbsp;
			        <select name='cng_id'>
                <option value="">����</option>
				        <option value="XXXXXX">�̰���(XXXXXX)</option>
                <%	if(user_size > 0){
											for(int i = 0 ; i < user_size ; i++){
												Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                <%		}
										}
								%>
              </select>
			      </td>
          </tr>
        </table>
	    </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>    
    <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	  <tr>
	    <td align="right">	     
		    <input type="button" name="b_selete" value="����" onClick="javascript:save();">	
      </td>
	  </tr>
	  <%}%>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
//-->
</script>
</body>
</html>
