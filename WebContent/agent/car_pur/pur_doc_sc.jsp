<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*"%>
<%@ include file="/agent/cookies.jsp" %>

<%
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	String valus = 	"?user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+
				   	"&sh_height="+height+"";
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�ŷ�ó ���� 
	function view_client(rent_mng_id, rent_l_cd, r_st)
	{
		var SUBWIN= "/agent/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;
		window.open(SUBWIN, "View_Client", "left=50, top=50, width=820, height=800, resizable=yes, scrollbars=yes, status=yes");
	}

	//�����������
	function view_emp(emp_id){
		var fm = document.form1;
		window.open("/agent/car_office/car_office_p_s.jsp?user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/commi_pay_s_frame.jsp&cmd=view&emp_id="+emp_id, "VIEW_EMP", "left=50, top=50, width=850, height=600, resizable=yes, scrollbars=yes, status=yes");
	}
	
	//���ݹ�������
	function view_con_doc(rent_mng_id, rent_l_cd){
		var fm = document.form1;
		 		   
		var SUBWIN= "/agent/car_pur/view_con_doc.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd;
		window.open(SUBWIN, "COMMI_PAY", "left=50, top=50, width=720, height=650, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	function doc_action(scan_doc_cnt, chk_cnt, mode, rent_mng_id, rent_l_cd, doc_no, doc_bit, car_off_nm){
		var fm = document.form1;
		fm.mode.value 			= mode;
		fm.rent_mng_id.value 		= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;
		fm.doc_no.value 		= doc_no;
		
		if(car_off_nm == ''){
			alert('��������Ұ� ��ϵ��� �ʾҽ��ϴ�. ���������� �켱 ����Ͻʽÿ�.');
			return;
		}
			
		if(doc_no == ''){
			if(scan_doc_cnt > 0){
				if(chk_cnt>0){
					alert('�̰����Դϴ�. �������� ������ ��������� �����մϴ�.');
					return;
				}else{
					fm.action = 'pur_doc_i.jsp';
				}
			}else{				
				alert('��༭ ��ĵ�� �����ϴ�. Ȯ���Ͻʽÿ�.');
				return;
			}
		}else{
			fm.action = 'pur_doc_u.jsp';			
		}
		
		fm.target = 'd_content';
		fm.submit();
	}
	
	//������
	function doc_cancel(doc_no, rent_mng_id, rent_l_cd){
		var fm = document.form1;
		fm.doc_no.value 		= doc_no;		
		fm.rent_mng_id.value 		= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;			
		fm.action = 'pur_doc_d_a.jsp';
		fm.target = 'd_content';
		fm.submit();		
	}
	
	//��ĵ���� ����
	function view_scan(m_id, l_cd)
	{
		window.open("/agent/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) {
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();		
	}	
	
	//������ ����
	function select_purs_amt(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var purs_amt = 0;
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
					purs_amt = purs_amt + toInt(idnum);
				}
			}
		}	
		if(cnt == 0){
		 	document.form1.est_amt.value = 0;
		}			
		document.form1.est_amt.value = parseDecimal(purs_amt);
	}		
	
	//��ĵ���� ����
	function reg_delay_cont(m_id, l_cd)
	{
		window.open("reg_delay_cont.jsp?m_id="+m_id+"&l_cd="+l_cd, "REG_DELAY", "left=100, top=10, width=600, height=300, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	//�ڵ��� Ź�� ���Ƿ�
	function reg_cons(m_id, l_cd){
		window.open("reg_cons.jsp?m_id="+m_id+"&l_cd="+l_cd, "REG_CONS", "left=100, top=10, width=720, height=750, resizable=yes, scrollbars=yes, status=yes");				
	}		
		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/agent/car_pur/pur_doc_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='doc_no' value=''>  
  <input type='hidden' name='mode' value=''>    
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�� <input type='text' name='size' value='' size='4' class=whitenum> ��</span>
	    <!-- 
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		* ���⿹��ݾ� : <input type='text' name='est_amt' maxlength='10' value='' class='whitenum' size='10'>��
		 -->
		</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="pur_doc_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
	    <td>�� ������ݹ���ó�� �̰Ḯ��Ʈ�� �ȳ����� ����� ���������� �������-�����翡 �Է� ���θ� Ȯ���ϼ���.</td>
	</tr>	
</table>
</form>
</body>
</html>