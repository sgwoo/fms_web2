<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String temp = "";
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-170;//��Ȳ ���μ���ŭ ���� ���������� ������

	String valus = 	"?height="+height+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc+
				   	"&sh_height="+height+"";
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//��ǰ���� ����
function view_est(m_id, l_cd) {
	window.open("/fms2/lc_rent/reg_est.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>&mode=board", "VIEW_STAT", "left=100, top=100, width=620, height=400, resizable=yes, scrollbars=yes, status=yes");		
}

//�����ȣ ���
function reg_estcarno(m_id, l_cd, c_st, u_st, car_no_stat) {
	window.open("reg_estcarno.jsp?m_id="+m_id+"&l_cd="+l_cd+"&c_st="+c_st+"&u_st="+u_st+"&br_id=<%=br_id%>&mode=board&car_no_stat="+car_no_stat, "REG_ESTCARNO", "left=100, top=100, width=620, height=700, resizable=yes, scrollbars=yes, status=yes");					
}

//�����ȣ ���
function reg_estcarnum(m_id, l_cd) {
	window.open("reg_estcarnum.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>&mode=board", "REG_ESTCARNO", "left=100, top=100, width=620, height=400, resizable=yes, scrollbars=yes, status=yes");					
}

//�ŷ�ó ���� 
function view_client(rent_mng_id, rent_l_cd, r_st, car_mng_id) {
	var SUBWIN= "/fms2/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;
	window.open(SUBWIN, "View_Client", "left=50, top=50, width=720, height=600, resizable=yes, scrollbars=yes, status=yes");
}

//�˾������� ����
function MM_openBrWindow(theURL,winName,features) {
	theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
	window.open(theURL,winName,features);
}	

//�˾������� ����
function MM_openBrWindow2(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}

//�˾������� ����
function MM_openBrWindow3(theURL,winName,features) { //v2.0
	theURL = "https://fms3.amazoncar.co.kr"+theURL;
	window.open(theURL,winName,features);
}			

//��Ͽ�������Ʈ
function select_rents() {
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
	 	alert("����� �����ϼ���.");
		return;
	}	
			
	fm.target = "_blank";
	fm.action = "rent_board_excel.jsp";
	fm.submit();	
}	

//��Ͽ�������Ʈ
function select_rents2() {
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
	 	alert("����� �����ϼ���.");
		return;
	}	
			
	fm.target = "_blank";
	fm.action = "rent_board_excel_incheon.jsp";
	fm.submit();	
}		

//��Ͽ�������Ʈ
function select_rents_park() {
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
	 	alert("����� �����ϼ���.");
		return;
	}	
			
	fm.target = "_blank";
	fm.action = "rent_board_excel_park.jsp";
	fm.submit();	
}		

//����� ��������Ʈ-������ ��û
function select_rents3() {
	var fm = inner.document.form1;	
	
	fm.mod_st.value = document.form1.mod_st.value;
	
	fm.target = "_blank";
	fm.action = "rent_board_excel3.jsp";
	fm.submit();	
}

//����� ��������Ʈ-������ ��û
function select_rents_ins38() {
	var fm = inner.document.form1;	
	
	fm.mod_st.value = document.form1.mod_st.value;
	
	fm.target = "_blank";
	fm.action = "rent_board_excel_ins38.jsp";
	fm.submit();	
}

function req_fee_start_act(m_title, m_content, bus_id, agent_emp_nm, agent_emp_m_tel, rent_l_cd) {
	var fm = document.form1;
	fm.send_id.value 	= fm.user_id.value;
	fm.m_title.value 	= m_title;		
	fm.m_content.value 	= m_content;		
	fm.rece_id.value 	= bus_id;		
	fm.agent_emp_nm.value 	= agent_emp_nm;		
	fm.agent_emp_m_tel.value 	= agent_emp_m_tel;
	fm.rent_l_cd.value = rent_l_cd;
	fm.action = "/acar/memo/memo_send_mini.jsp";
	window.open("about:blank", "MEMO_SEND", "left=20, top=50, width=550, height=530, scrollbars=yes, status=yes");
	fm.target = "MEMO_SEND";
	fm.submit();	
}

function req_fee_start_act2(m_title, m_content, rpt_no, firm_nm, car_nm, car_num, bus_id, agent_emp_nm, agent_emp_m_tel, rent_l_cd) {
	var fm = document.form1;
	fm.send_id.value = fm.user_id.value;
	fm.m_title.value = m_title;		
	fm.m_content.value = m_content;
	
	fm.rpt_no.value = rpt_no;
	fm.firm_nm.value = firm_nm;
	fm.car_nm.value 	= car_nm;
	fm.car_num.value = car_num;
	
	fm.rece_id.value = bus_id;
	fm.agent_emp_nm.value = agent_emp_nm;
	fm.agent_emp_m_tel.value = agent_emp_m_tel;
	fm.rent_l_cd.value = rent_l_cd;
	fm.action = "/acar/memo/memo_send_mini.jsp";
	window.open("about:blank", "MEMO_SEND", "left=20, top=50, width=550, height=530, scrollbars=yes, status=yes");
	fm.target = "MEMO_SEND";
	fm.submit();
}

// ������ڿ��� ������ ���� ��û ���� ������ 2018.01.16
function req_dlv_emp_act(m_title, rent_mng_id, rent_l_cd, reg_est_dt, car_nm, rpt_no) {
	var fm = document.form1;
	fm.send_id.value		= fm.user_id.value;
	fm.m_title.value		= m_title;
	fm.m_content.value	= reg_est_dt;
	fm.m_content.value	+= "@";
	fm.m_content.value	+= car_nm;
	fm.m_content.value	+= "@";
	fm.m_content.value	+= rpt_no;
	fm.rent_mng_id.value	= rent_mng_id;
	fm.rent_l_cd.value		= rent_l_cd;
	fm.reg_est_dt.value		= reg_est_dt;
	fm.car_nm.value			= car_nm;
	fm.rpt_no.value			= rpt_no;
	fm.action = "/acar/memo/memo_send_mini.jsp";
	window.open("about:blank", "MEMO_SEND", "left=20, top=50, width=550, height=530, scrollbars=yes, status=yes");
	fm.target = "MEMO_SEND";
	fm.submit();
}

function req_partner(m_title, m_content, user_work) {
	var fm = document.form1;
	fm.send_id.value 	= fm.user_id.value;
	fm.m_title.value 	= m_title;
	fm.m_content.value 	= m_content;
	fm.user_work.value 	= user_work;
	fm.action = "/acar/memo/memo_send_mini_partner.jsp";
	window.open("about:blank", "MEMO_SEND", "left=20, top=50, width=550, height=530, scrollbars=yes, status=yes");
	fm.target = "MEMO_SEND";
	fm.submit();
}

//��༭ ���� ����
function view_cont(m_id, l_cd, use_yn) {
	var fm = document.form1;
	fm.rent_mng_id.value = m_id;
	fm.rent_l_cd.value = l_cd;		
	fm.target ='d_content';
	if(use_yn == '')	fm.action = '../lc_rent/lc_b_s.jsp';
	else			fm.action = '../lc_rent/lc_c_frame.jsp';
	fm.submit();
}



function reg_blackboximg(tint_no, rent_mng_id, rent_l_cd) {
	window.open("/fms2/tint/reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/car_pur/rent_board_frame.jsp&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&tint_no="+tint_no, "SCAN", "left=10, top=10, width=720, height=300, scrollbars=yes, status=yes, resizable=yes");	
}

//�˾������� ����
function MM_openBrWindow(theURL,winName,features) { //v2.0
	theURL = "https://fms3.amazoncar.co.kr/data/"+theURL;
	window.open(theURL,winName,features);
}


function select_rents_ins_excel_com(){
	var fm = inner.document.form1;	
	//fm.ins_com_id.value = document.form1.ins_com_id.value;
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
	 	alert("����� �����ϼ���.");
		return;
	}	
			
	fm.target = "_blank";
	fm.action = "rent_board_excel_ins_com.jsp";
	fm.submit();
}

//���ݰ�꼭 �ϰ���� ��ư
function regAllTaxInvoice(){
	var fm = inner.document.form1;
	var len=fm.elements.length;	
	var cnt=0;
	var param="";
	for(var i=0 ; i<len ; i++){
		var ck=fm.elements[i];		
		if(ck.name == "ch_cd"){		
			if(ck.checked == true){
				param += ck.value + ",";
				cnt ++;
			}
		}
	}
	
	if(cnt == 0){
	 	alert("������� �� ���ݰ�꼭�� �ϰ���� �� ����� �����ϼ���.");
		return;
	}
	window.open("/fms2/car_pur/reg_all_tax_invoice.jsp?param="+param,'popup','width=1150,height=700,top=0,left=100,scrollbars=yes');
}

//������ȣ �ڵ���� ��ư	
function autoRegCarNo(){
	var fm = inner.document.form1;
	var len=fm.elements.length;	
	var cnt=0;
	var param="";
	for(var i=0 ; i<len ; i++){
		var ck=fm.elements[i];		
		if(ck.name == "ch_cd"){		
			if(ck.checked == true){
				param += ck.value + ",";
				cnt ++;
			}
		}
	}
	
	if(cnt == 0){
	 	alert("������ȣ�� �ڵ���� �� ����� �����ϼ���.");
		return;
	}else{
		if(confirm('������ ��࿡ ������/�ű� �ڵ��� ��ȣ�� ���Ƿ� �ڵ���� �˴ϴ�.\n\n������ ����� �� �� �� Ȯ�����ּ���.\n\n��� �Ͻðڽ��ϱ�?')){
			window.open("/fms2/car_pur/reg_estcarno_b.jsp?param="+param,'popup','width=700,height=700,top=0,left=100,scrollbars=yes');
		}
	}
}

//�ڵ��� ��� ȭ�� �̵� / 2017. 11. 28
function carRegList(rent_mng_id, rent_l_cd, car_mng_id, reg_gubun, udt_st){
	var theForm = document.form1;
	theForm.rent_mng_id.value 	= rent_mng_id;
	theForm.rent_l_cd.value 	= rent_l_cd;
	theForm.car_mng_id.value 	= car_mng_id;
	theForm.cmd.value 			= reg_gubun;
	theForm.udt_st.value		= udt_st;
	theForm.from_page.value	= "rbs";
	theForm.action = "/acar/car_register/register_frame.jsp";
	theForm.target = "d_content"
	//if(dlv_dt == ''){ alert('������ڰ� ������ ������� ���մϴ�.'); return; }
	theForm.submit();
}	

function msg_reg_car(){
	var fm = document.form1;
	fm.target ='i_no';
	fm.action = 'reg_msg_car_a.jsp';
	fm.submit();	
}

function view_com_cons(){
	window.open("view_com_cons_tel.jsp",'popup','width=700,height=700,top=0,left=100,scrollbars=yes');
}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'> 
  <input type='hidden' name='sort' 	value='<%=sort%>'>  
  <input type='hidden' name='asc' 	value='<%=asc%>'>       
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/car_pur/rent_board_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='doc_no' value=''>  
  <input type='hidden' name='mode' value=''>    
  <input type='hidden' name='send_id' value=''>    
  <input type='hidden' name='m_title' value=''>    
  <input type='hidden' name='m_content' value=''>
      
  <input type='hidden' name='rpt_no' value=''>
  <input type='hidden' name='firm_nm' value=''>
  <input type='hidden' name='car_nm' value=''>
  <input type='hidden' name='car_num' value=''>
  
  <input type='hidden' name='reg_est_dt' value=''>
      
  <input type='hidden' name='rece_id' value=''>    
  <input type='hidden' name='user_work' value=''>    
  <input type='hidden' name='agent_emp_nm' value=''>    
  <input type='hidden' name='agent_emp_m_tel' value=''>    
  <input type='hidden' name='car_mng_id' value=''>
  <input type='hidden' name='cmd' value=''>
  <input type='hidden' name='udt_st' value=''>
  
  <input type="hidden" name="temp2">
  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td>
	    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�� <input type='text' name='size' value='' size='4' class=whitenum> ��</span>&nbsp;
			<a href="javascript:select_rents();">[�μ�]</a>&nbsp;
			<a href="javascript:select_rents2();" style="margin-right: 100px;">[����]</a>&nbsp;<!-- (�������� �μ�̸�����-����������(����|���40%|�¿쿩������)�ؾ� A4�� ���� ����Ҽ� �ֽ��ϴ�. -->
	   		<%//if( nm_db.getWorkAuthUser("��ǰ�غ��Ȳ��Ͼ���",user_id) || user_id.equals("000026") ){%>		
			<!--&nbsp;&nbsp;<a href="javascript:select_rents_park();" >[�����忢��]</a>  //Ȯ���Ǹ� ���� --> 
	  		<% //} %>
			<a href="javascript:req_partner('Ź�۾�ü �뺸', '���� ���� 00���Դϴ�.', 'Ź�۾�ü')" onMouseOver="window.status=''; return true" title='Ź�۾�ü�� �뺸�ϱ�'>[Ź�۾�ü���ڹ߼�]</a>&nbsp;
			<%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�ӿ�",user_id) || nm_db.getWorkAuthUser("������",user_id)){%>
			<!-- 
			*������
			<select name="mod_st">
                    <option value="1">1��</option>
                    <option value="2">2��</option>
                    <option value="3">3��</option>
                    <option value="4">4��</option>
                    <option value="5">5��</option>
                    <option value="6">6��</option>
                    <option value="7">7��</option>
                    <option value="8">8��</option>
                    <option value="9">9��</option>
                    <option value="10">10��</option>
                </select>
         	-->        
        	<input type='hidden' name='mod_st' value='1'>        
			<a href="javascript:select_rents3();">[���迢��]</a>&nbsp;			
			<a href="javascript:select_rents_ins38();">[�������ս�û��]</a>&nbsp;
			<!--
			<select name="ins_com_id">
                    <option value="0038">����ī��������</option>
                    <option value="0008">DB���غ���</option>
            </select>
    		--> 
			<input type="button" class="button" id='ins_excel_com' value='���� �ű԰��� ��û ���' onclick='javascript:select_rents_ins_excel_com();'>&nbsp;
			<%}%>
			<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){ %>
			<input type="button" class="button" id='regalltax' value='���ݰ�꼭 �ϰ����' onclick="javascript:regAllTaxInvoice();">&nbsp;
			<%}%>
			<%if(auth_rw.equals("6")){ %>
			<input type="button" class="button" id='regcarno' value='������ȣ �ڵ����' onclick="javascript:autoRegCarNo();">&nbsp;
			<%} %>
			<input type="button" class="button" id='msgregcar' value='������ϿϷ�' onclick='javascript:msg_reg_car();'>&nbsp;
			<input type="button" class="button" id='viewcomcons' value='���Ź�ۻ�' onclick='javascript:view_com_cons();'>&nbsp;
			<a href="https://smartwap.glovis.net/mgr/delivery/deliveryState.jsp?pContName=�ֽ�ȸ��Ƹ���ī" target="_blank" style="padding: 5px 15px; background: #efefef; text-decoration: none; border-radius: 5px; color: #000000; border: 1px solid #000; font-size: 15px;">���Ź������</a>&nbsp;
			<!-- <input type="button" class="button" id='viewcomcons' value='���Ź������' onclick="window.open('https://smartwap.glovis.net/mgr/delivery/deliveryState.jsp?pContName=�ֽ�ȸ��Ƹ���ī','delivery','width=800, height=800, toolbar=no, menubar=no, scrollbars=auto, resizable=yes');return false;"> -->
		</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<!-- 2017. 12. 13 �Ϻη� ��ǰ�غ��Ȳ ������ ����ȭ ���� -->
				<tr>
					<td>
						<iframe src="rent_board_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
