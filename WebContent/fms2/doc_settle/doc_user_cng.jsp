<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.doc_settle.*, acar.car_register.*, acar.cont.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
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
	
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_user	= request.getParameter("doc_user")==null?"":request.getParameter("doc_user");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
	
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
			fm.action='doc_user_cng_a.jsp';
			fm.target='i_no';
			fm.submit();
		}		
	}
	
	function settle_req(){
		var fm = document.form1;
		
		if(confirm('��û�Ͻðڽ��ϱ�?')){		
			fm.action='doc_sanction_a.jsp';
			fm.target='i_no';
//			fm.target='_blank';
			fm.submit();
		}		
	}	
	
	function settle_cancel(){
		var fm = document.form1;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){
		if(confirm('��¥�� �����Ͻðڽ��ϱ�?')){
			fm.action='doc_cancel_a.jsp';
			fm.target='i_no';
			fm.submit();
		}}
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
  <input type='hidden' name='doc_no' 	value='<%=doc_no%>'>
  <input type='hidden' name='doc_bit' 	value='<%=doc_bit%>'>
  <input type='hidden' name='doc_user' 	value='<%=doc_user%>'>  
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
	  <td align='left'>
	   		<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ó���� > <span class=style5>������ ����</span></span></td>
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
            <td width='20%' class='title'>������ȣ</td>
            <td>&nbsp;
			  <%=doc_no%>
			</td>
		  </tr>
		  <tr>
            <td width='20%' class='title'>��������</td>
            <td>&nbsp;
			  <%if(doc.getDoc_st().equals("1")){%>��������<%}%>
			  <%if(doc.getDoc_st().equals("2")){%>Ź���Ƿ�<%}%>
			  <%if(doc.getDoc_st().equals("3")){%>Ź�۰���<%}%>
			  <%if(doc.getDoc_st().equals("4")){%>�������<%}%>
			  <%if(doc.getDoc_st().equals("5")){%>������<%}%>			  			  			  			  
			  <%if(doc.getDoc_st().equals("6")){%>��ǰ�Ƿ�<%}%>
			  <%if(doc.getDoc_st().equals("7")){%>��ǰ����<%}%>			  			  			  			  
			  <%if(doc.getDoc_st().equals("11")){%>��������<%}%>			  			  			  			  			  
			</td>
          </tr>		  
		  <tr>
            <td width='20%' class='title'>������</td>
            <td>&nbsp;
			  <%=c_db.getNameById(doc_user,"USER")%>
			</td>
          </tr>		  
		  <tr>
            <td width='20%' class='title'>������</td>
            <td>&nbsp;
			  <select name='cng_id'>
                <option value="">����</option>
				<option value="XXXXXX">�̰���(XXXXXX)</option>
                <%	if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                <%		}
					}%>
              </select>
			</td>
          </tr>		  
        </table>
	  </td>
    </tr>
    <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	<tr>
	  <td align="right">
	     
		<input type="button" name="b_selete" value="����" onClick="javascript:save();">	
      </td>
	</tr>		
	<%}%>
	<%if(nm_db.getWorkAuthUser("������",user_id)){%>
    <tr>
	  <td><hr></td>
	</tr>	
    <tr>
	  <td>&nbsp;</td>
	</tr>		
    <tr>
	  <td><input type="button" name="b_selete" value="������û" onClick="javascript:settle_req();">	</td>
	</tr>	
    <tr>
	  <td>&nbsp;</td>
	</tr>	
	<!--
    <tr>
	  <td><input type="button" name="b_selete" value="������" onClick="javascript:settle_cancel();">	</td>
	</tr>	
	-->
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
