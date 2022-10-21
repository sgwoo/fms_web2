<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+
				   	"&sh_height="+height+"";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function pay_doc_action(doc_code, p_est_dt, p_gubun, p_br_id, doc_bit, doc_no, p_req_dt, p_est_dt2){	
		window.open('pay_doc.jsp<%=valus%>&doc_code='+doc_code+'&p_est_dt='+p_est_dt+'&p_est_dt2='+p_est_dt2+'&p_req_dt='+p_req_dt+'&p_gubun='+p_gubun+'&p_br_id='+p_br_id+'&doc_bit='+doc_bit+'&doc_no='+doc_no+'&mode='+document.form1.mode.value+'&from_page='+document.form1.from_page.value, "PAY_DOC", "left=0, top=0, width=1400, height=850, scrollbars=yes, status=yes, resizable=yes");
	}
		
	//���⼭�ۼ�
	function select_pays(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("����� ����� �����ϼ���.");
			return;
		}	
		
		window.open('about:blank', "PAY_DOC", "left=0, top=0, width=1400, height=900, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "PAY_DOC";
		fm.action = "pay_docs.jsp";
		fm.submit();	
	}		
	
	//���
	function select_cancel(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					cnt++;					
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("1���̻� �����ϼ���.");
			return;
		}	

		if(!confirm('������� �Ͻðڽ��ϱ�?')){	return; }
		if(!confirm('�ٽ� Ȯ���մϴ�. ������� �Ͻðڽ��ϱ�?')){	return; }
		if(!confirm('������ ������� �Ͻðڽ��ϱ�?')){	return; }
		if(!confirm('��¥�� ������� �Ͻðڽ��ϱ�?')){	return; }
		
		window.open("about:blank", "PAY_D_CANCEL", "left=10, top=10, width=1000, height=400, scrollbars=yes");			
			
		fm.target = "PAY_D_CANCEL";
		fm.action = "pay_d_cancel_a.jsp";
		fm.submit();	
	}										
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='from_page' value='/fms2/pay_mng/pay_d_frame.jsp'>  
  <input type='hidden' name='mode' value=''>      
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td>�� <input type='text' name='size' value='' size='4' class=whitenum> ��
	  <%if((auth_rw.equals("4")||auth_rw.equals("6")) || (nm_db.getWorkAuthUser("������",user_id))){%>   
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
	  <a href="javascript:select_pays();"><img src=/acar/images/center/button_gjga.gif align=absmiddle border=0></a>
	  &nbsp;&nbsp;
	  <a href="javascript:select_cancel();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_cancel_gj.gif" align="absmiddle" border="0"></a>
	  &nbsp;	  
	  <!--
	  <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>û������</span>&nbsp;<input type='text' name="req_dt" value='<%=AddUtil.getDate()%>' size='11' class='text'>&nbsp;&nbsp;&nbsp; 
	  <a href="javascript:select_pay();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_gjyc.gif" align="absmiddle" border="0"></a>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	 
	  <a href="javascript:select_del();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_delete.gif" align="absmiddle" border="0"></a>
	  &nbsp;
	  -->
	  <%}%>	    	  
	  </td>
	</tr>
	<tr>
	  <td>
		<table border="0" cellspacing="0" cellpadding="0" width=100%>
		  <tr>
			<td>
			  <iframe src="pay_d_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
			</td>
		  </tr>
		</table>
	  </td>
	</tr>
  </table>
</form>
</body>
</html>
