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
	String coll_yn 	= request.getParameter("coll_yn")==null?"":request.getParameter("coll_yn");
	String coll_yes 	= request.getParameter("coll_yes")==null?"":request.getParameter("coll_yes"); //���ݰ� ����
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	
	String valus = 	"?coll_yn="+coll_yn+ "&coll_yes="+coll_yes+ "&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
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
	//��������
	function FineInReg(){
	
		var fm = i_no.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}
			
		if(cnt == 0){
		 	alert("���·Ḧ �����ϼ���.");
			return;
		}	
			
		if(!confirm('���·� û������ �����Ͻðڽ��ϱ�?')){	return;	}
		fm.action = "forfeit_proxy_mail_i_a.jsp";
		fm.target = "ii_no";
		fm.submit();
			
	}

	function reg_re_mail(m_id, l_cd, car_id, seq_no, cust_nm, dem_dt, e_dem_dt){
	
		var fm = i_no.document.form1;	
							
		if(!confirm('���·� û������ ������Ͻðڽ��ϱ�?')){	return;	}
		fm.action = "forfeit_proxy_mail_i_a.jsp?ch_l_cd="+m_id+"^"+l_cd+"^"+car_id+"^"+seq_no+"^"+cust_nm+"^"+dem_dt+"^"+e_dem_dt+"^";
		fm.target = "ii_no";
		fm.submit();
			
	}
	

	//���·� û������  ����
	function view_mail(m_id, l_cd, c_id, tm_st, accid_id, serv_id, mng_id, dem_dt, e_dem_dt, seq_no){			
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
	
		fm.action="/mailing/rent/email_fine_bill_sn.jsp?m_id="+m_id+"&l_cd="+l_cd+"&dem_dt="+dem_dt+"&e_dem_dt="+e_dem_dt+"&seq_no="+seq_no;		
		
		fm.target="_blank";
		fm.submit();
	}	

	
	//���±� ���γ��� ����
	function view_forfeit(m_id, l_cd, c_id, seq_no){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.seq_no.value = seq_no;
		fm.target = "d_content";
//		fm.action = "/acar/forfeit_mng/forfeit_i_frame.jsp";
		fm.action = "/acar/fine_mng/fine_mng_frame.jsp";		
		fm.submit();
	}
	
	//�� ����
	function view_client(m_id, l_cd, r_st){
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=20, top=20, width=820, height=700, scrollbars=yes");
	}
	
	//���� 
	function pop_excel(){
		var fm = i_no.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("������ ����� ����� �����ϼ���.");
			return;
		}	
		fm.target = "_blak";
		fm.action = "popup_excel.jsp";
		fm.submit();
	}		

	//���
	function reg_forfeit(){
		var fm = document.form1;
		fm.target = "d_content";
//		fm.action = "/acar/forfeit_mng/forfeit_i_frame.jsp";
		fm.action = "/acar/fine_mng/fine_mng_frame.jsp";		
		fm.submit();
	}
	
	//���ݰ��� �̵�
	function forfeit_in(){
		var fm = document.form1;
		fm.gubun2.value = '6';
		fm.target = "d_content";
		fm.action = "/acar/con_forfeit/forfeit_frame_s.jsp";
		fm.submit();
	}	
	//��Ȳ
	function  view_stat(){
		var taxInvoice = window.open("about:blank", "Stat", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=850px, height=250px");
		document.form1.action="forfeit_sc_stat.jsp";
		document.form1.method="post";
		document.form1.target="Stat";
		document.form1.submit();
	}	
	
	//���Ϲ߼� - û���� �߼�
	function FineInMail(){
	
		var fm = i_no.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}
			
		if(cnt == 0){
		 	alert("���·Ḧ �����ϼ���.");
			return;
		}	
			
		if(!confirm('�������·� ������ �����Ͻðڽ��ϱ�?')){	return;	}
		fm.action = "forfeit_sn_mail_a.jsp";
		fm.target = "ii_no";
		fm.submit();
			
	}
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='m_id' value=''>
  <input type='hidden' name='l_cd' value=''>
  <input type='hidden' name='c_id' value=''>
  <input type='hidden' name='accid_id' value=''>
  <input type='hidden' name='serv_id' value=''>
  <input type='hidden' name='seq_no' value=''>
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
  <input type='hidden' name='from_page' value='/fms2/forfeit_mng/forfeit_de_frame.jsp'>  
  <input type='hidden' name='reqseq'    value=''>    
  <input type='hidden' name='i_seq'    	value=''>      
  <table border="0" cellspacing="0" cellpadding="0" width=100%>  
 <% 	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
  <tr> 
    <td align="right" ><%if(user_id.equals("000096")){%> <a href="javascript:FineInMail();"><img src=/acar/images/center/button_bh.gif border=0 align=absmiddle></a> <%}%>
    </td>
   </tr>
<%	}%> 
  <tr>
	  <td>�� <input type='text' name='size' value='' size='4' class=whitenum> ��	    	  
	  </td>
	</tr>
	<tr>
	  <td>
		<table border="0" cellspacing="0" cellpadding="0" width=100%>
		  <tr>
			<td>
			  <iframe src="forfeit_de_sc_in.jsp<%=valus%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
			</td>
		  </tr>
		</table>
	  </td>
	</tr>
  </table>
</form>
<iframe src="about:blank" name="ii_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
