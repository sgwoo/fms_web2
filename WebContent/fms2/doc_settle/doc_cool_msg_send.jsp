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
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
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
		
		if(fm.sub.value == "")		{ 	alert("������ �Է��Ͻʽÿ�."); 			return;	}		
		if(fm.cont.value == "")		{ 	alert("������ �Է��Ͻʽÿ�."); 			return;	}		
		if(fm.dest_id.value == "")	{ 	alert("��������� �Է��Ͻʽÿ�."); 		return;	}		
		
		if(confirm('����Ͻðڽ��ϱ�?')){		
			fm.action='doc_cool_msg_send_a.jsp';
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
  <input type='hidden' name='doc_no' 	value='<%=doc_no%>'>
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
	  <td align='left'>
	   		<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ó���� > <span class=style5>�޽��� �߼�</span></span></td>
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
            <td width='12%' class='title'>������ȣ</td>
            <td>&nbsp;
			  <%=doc_no%>
			</td>
		  </tr>
		  <tr>
            <td class='title'>��������</td>
            <td>&nbsp;
			  <%if(doc.getDoc_st().equals("1")){%>��������<%}%>
			  <%if(doc.getDoc_st().equals("2")){%>Ź���Ƿ�<%}%>
			  <%if(doc.getDoc_st().equals("3")){%>Ź�۰���<%}%>
			  <%if(doc.getDoc_st().equals("4")){%>�������<%}%>
			  <%if(doc.getDoc_st().equals("5")){%>������<%}%>			  			  			  			  
			  <%if(doc.getDoc_st().equals("6")){%>��ǰ�Ƿ�<%}%>
			  <%if(doc.getDoc_st().equals("7")){%>��ǰ����<%}%>			  			  			  			  
			  <%if(doc.getDoc_st().equals("11")){%>��������<%}%>			  			  			  			  			  
              <%if(doc.getDoc_st().equals("8")){%>Ư�ٽ�û<%}%>
              <%if(doc.getDoc_st().equals("21")){%>������û<%}%>
              <%if(doc.getDoc_st().equals("31")){%>��ݱ��<%}%>
              <%if(doc.getDoc_st().equals("32")){%>�۱ݿ�û<%}%>
			</td>
          </tr>		  
		  <tr>
            <td class='title'>����</td>
            <td>&nbsp;
			  <input type='text' name='sub' size='75' class='text' value='<%=doc.getSub()%>' style='IME-MODE: active'>			  
			</td>
          </tr>		  
		  <tr>
            <td class='title'>����</td>
            <td>&nbsp;
			  <textarea rows='8' cols='75' name='cont'><%=doc.getCont()%></textarea>
			</td>
          </tr>		  		  
		  <tr>
            <td class='title'>�޴»��</td>
            <td>&nbsp;
			  <select name='dest_id'>
                <option value="">����</option>
				<%if(!doc.getUser_id1().equals("") && !doc.getUser_id1().equals("XXXXXX")){%><option value='<%=doc.getUser_id1()%>'>[���] <%=doc.getUser_nm1()%> <%=c_db.getNameById(doc.getUser_id1(),"USER")%></option><%}%>
				<%if(!doc.getUser_id2().equals("") && !doc.getUser_id2().equals("XXXXXX")){%><option value='<%=doc.getUser_id2()%>'><%if(!doc.getUser_dt2().equals("")){%>[����]<%}else{%>[�̰�]<%}%> <%=doc.getUser_nm2()%> <%=c_db.getNameById(doc.getUser_id2(),"USER")%></option><%}%>
				<%if(!doc.getUser_id3().equals("") && !doc.getUser_id3().equals("XXXXXX")){%><option value='<%=doc.getUser_id3()%>'><%if(!doc.getUser_dt3().equals("")){%>[����]<%}else{%>[�̰�]<%}%> <%=doc.getUser_nm3()%> <%=c_db.getNameById(doc.getUser_id3(),"USER")%></option><%}%>
				<%if(!doc.getUser_id4().equals("") && !doc.getUser_id4().equals("XXXXXX")){%><option value='<%=doc.getUser_id4()%>'><%if(!doc.getUser_dt4().equals("")){%>[����]<%}else{%>[�̰�]<%}%> <%=doc.getUser_nm4()%> <%=c_db.getNameById(doc.getUser_id4(),"USER")%></option><%}%>
				<%if(!doc.getUser_id5().equals("") && !doc.getUser_id5().equals("XXXXXX")){%><option value='<%=doc.getUser_id5()%>'><%if(!doc.getUser_dt5().equals("")){%>[����]<%}else{%>[�̰�]<%}%> <%=doc.getUser_nm5()%> <%=c_db.getNameById(doc.getUser_id5(),"USER")%></option><%}%>
				<%if(!doc.getUser_id6().equals("") && !doc.getUser_id6().equals("XXXXXX")){%><option value='<%=doc.getUser_id6()%>'><%if(!doc.getUser_dt6().equals("")){%>[����]<%}else{%>[�̰�]<%}%> <%=doc.getUser_nm6()%> <%=c_db.getNameById(doc.getUser_id6(),"USER")%></option><%}%>
				<%if(!doc.getUser_id7().equals("") && !doc.getUser_id7().equals("XXXXXX")){%><option value='<%=doc.getUser_id7()%>'><%if(!doc.getUser_dt7().equals("")){%>[����]<%}else{%>[�̰�]<%}%> <%=doc.getUser_nm7()%> <%=c_db.getNameById(doc.getUser_id7(),"USER")%></option><%}%>
				<%if(!doc.getUser_id8().equals("") && !doc.getUser_id8().equals("XXXXXX")){%><option value='<%=doc.getUser_id8()%>'><%if(!doc.getUser_dt8().equals("")){%>[����]<%}else{%>[�̰�]<%}%> <%=doc.getUser_nm8()%> <%=c_db.getNameById(doc.getUser_id8(),"USER")%></option><%}%>
				<%if(!doc.getUser_id9().equals("") && !doc.getUser_id9().equals("XXXXXX")){%><option value='<%=doc.getUser_id9()%>'><%if(!doc.getUser_dt9().equals("")){%>[����]<%}else{%>[�̰�]<%}%> <%=doc.getUser_nm9()%> <%=c_db.getNameById(doc.getUser_id9(),"USER")%></option><%}%>
				<%if(!doc.getUser_id10().equals("") && !doc.getUser_id10().equals("XXXXXX")){%><option value='<%=doc.getUser_id10()%>'><%if(!doc.getUser_dt10().equals("")){%>[����]<%}else{%>[�̰�]<%}%> <%=doc.getUser_nm10()%> <%=c_db.getNameById(doc.getUser_id10(),"USER")%></option><%}%>
              </select>
			</td>
          </tr>		  
        </table>
	  </td>
    </tr>
	<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	<tr>
	  <td align="right">
		<input type="button" name="b_selete" value="�޽��� ������" onClick="javascript:save();">	
      </td>
	</tr>		
	<%}%>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
