<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String s_cpt = request.getParameter("s_cpt")==null?"":request.getParameter("s_cpt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 3; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	if(height < 50) height = 150;
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	// ���γ��� ����
	function view_fine_doc(doc_id){
		var fm = document.form1;
		fm.doc_id.value = doc_id;
		fm.target = "d_content";
		fm.action = "bank_doc_mng_c.jsp";
		fm.submit();
	}
	
	//��û�����
	function ObjectionPrint(doc_id, gov_id){
		var fm = document.form1;
		var SUMWIN = "";

		if ( gov_id == "0026") {
			SUMWIN="objection_print1.jsp?doc_id="+doc_id;	
		} else {
			SUMWIN="objection_print.jsp?doc_id="+doc_id;	
		}
			
		window.open(SUMWIN, "ObjectionPrint", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	//����ϱ�
	function FineDocPrint(doc_id, gov_id){
		var fm = document.form1;
		var SUMWIN = "";
		
		if( gov_id == "0026" ||  gov_id == "0037"){
			SUMWIN="bank_doc_print1.jsp?doc_id="+doc_id;	
		} else {		
			SUMWIN="bank_doc_print.jsp?doc_id="+doc_id;	
		}
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}
	
	//����ϱ�
	function FineDocPrint2(doc_id, gov_id, cnt){
		var fm = document.form1;
		var SUMWIN = "";
		
		SUMWIN="bank_doc_print_2.jsp?doc_id="+doc_id+"&cnt="+cnt;	

		window.open(SUMWIN, "DocPrint2", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}
	
	function FineIP_DT(doc_id, gov_id, ip_dt){
		var fm = document.form1;
		var SUMWIN = "";
		
		SUMWIN="ip_dt_i.jsp?doc_id="+doc_id+"&gov_id="+gov_id+"&ip_dt="+ip_dt;	

		window.open(SUMWIN, "IP_DT", "left=50, top=50, width=400, height=200, scrollbars=yes, status=yes");			
	}
		

	//�����ڱ����� 
	function select_banks(){
			var fm = i_no.document.form1;	
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
			 	alert("������ ����� �����ϼ���.");
				return;
			}	
			
			
			if(confirm('����Ͻðڽ��ϱ�?'))
			{
				fm.target = "d_content";
				fm.action = "bank_fund_a.jsp";
				fm.submit();	
			}
			
	}		


	//����ϱ�
	function objection_result(){
		var fm = document.form1;
		var SUMWIN = "";
		
		SUMWIN="objection_result.jsp";	

		window.open(SUMWIN, "DocPrint2", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}
	
	//�ڵ�������� ����ϱ�
	function ObjectionPrintAll2(){
		var fm = i_no.document.form1;	
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
		
		
		if(confirm('����Ͻðڽ��ϱ�?'))
		{
			
			fm.target = "_blank";			
			fm.action = "objection_print_car_all.jsp";		
			fm.submit();		
			
	
		}		
	
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='doc_id' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='s_cpt' value='<%=s_cpt%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
   <tr>
		<td>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>				
			        <td align='left'>
			         <%if( user_id.equals("000048") || user_id.equals("000063")  || user_id.equals("000029") || user_id.equals("000004")  ) {%>
			        <a href="javascript:select_banks();">[�����ڱ�����]</a>&nbsp;&nbsp;
			        <a href="javascript:objection_result();">[ī���Һ� ���]</a>&nbsp;&nbsp;
			        <a href="javascript:ObjectionPrintAll2();">[�ڵ�������� ���]</a>
			        <% } %>			        
				  </td>
				</tr>
			</table>
		</td>
  </tr>	
	
  <tr>
		<td>     
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
			  <tr>
				<td align='center'>
				  <iframe src="./bank_doc_mng_sc_in.jsp?s_cpt=<%=s_cpt%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun=<%=gubun%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&sh_height=<%=height%>&height=<%=height%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
				  </iframe>
				</td>
			  </tr>
			</table>
	  </td>	   
  </tr>
</table>
</form>
</body>
</html>
