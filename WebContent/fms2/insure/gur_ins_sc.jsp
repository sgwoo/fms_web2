<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")		==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 1; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+
				   	"&sh_height="+height+"";
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
	//�ŷ�ó ���� 
	function view_client(rent_mng_id, rent_l_cd, r_st)
	{
		var SUBWIN= "/fms2/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;
		window.open(SUBWIN, "View_Client", "left=50, top=50, width=820, height=700, resizable=yes, scrollbars=yes");

	}
	
	//�������躸��
	function gur_insure(rent_mng_id, rent_l_cd, client_id, rent_st)
	{	
		var SUBWIN="./gur_ins_id.jsp<%=valus%>&cmd=u&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st;	
		window.open(SUBWIN, "Gur_Insure", "left=100, top=100, width=730, height=400, scrollbars=yes");
	}
	
	//��û
	function select_emp_list(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var chk_value="";
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "chk"){		
				if(ck.checked == true){
					idnum=ck.value;
					cnt++;
				}
			}
		}	
		if(cnt == 0){
		 	alert("���Ͻô� ������ �������ּ���");
			return;
		}	
		
		/* fm.size.value = document.form1.size.value; */
		
		var act_ment="";
		act_ment="�ϰ��μ�";
				
		if(confirm(act_ment+' �Ͻðڽ��ϱ�?')){
	 		 window.open("" ,"form1", 
		       "toolbar=no, width=800, height=930, directories=no, status=no, scrollbars=yes, resizable=no"); 
			
			fm.action = "gur_ins_com_print.jsp";
			//fm.target = "_blank";
			fm.target = "form1";
			fm.method="post";
			fm.submit();	 
		}
	}
	
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="10" topmargin=0>

<form name='form1' method='post' target='d_content' action='/fms2/insure/gur_ins_sc.jsp'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/insure/gur_ins_s_frame.jsp'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�� <input type='text' name='size' value='' size='4' class=whitenum> ��</span>
	    	 &nbsp;&nbsp;&nbsp;&nbsp;
	    	<!--  <input type="button" class="button btn-submit" value="�ϰ��μ�" onclick="select_emp_list()"/> -->
	    </td>
		
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="gur_ins_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
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
