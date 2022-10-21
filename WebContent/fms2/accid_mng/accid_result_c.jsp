<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.cont.*"%>
<%@ page import="acar.accid.*, acar.insur.*, acar.res_search.*, acar.car_service.*, acar.doc_settle.*, acar.pay_mng.* "%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="oa_bean" class="acar.accid.OtAccidBean" scope="page"/>
<jsp:useBean id="oe_bean" class="acar.accid.OneAccidBean" scope="page"/>
<jsp:useBean id="my_bean2" class="acar.accid.MyAccidBean" scope="page"/>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="s_bean2" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="s_bean3" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="si_bean" class="acar.car_service.ServItem2Bean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//@ author : JHM - ���ó�������������
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	String mode = request.getParameter("mode")==null?"0":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");//��������ȣ
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");//����ȣ
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");//�ڵ���������ȣ
	
	String dlv_mon = request.getParameter("dlv_mon")==null?"":request.getParameter("dlv_mon");
	String car_amt = request.getParameter("car_amt")==null?"":request.getParameter("car_amt");
	String tot_amt = request.getParameter("tot_amt")==null?"":request.getParameter("tot_amt");
	String req_est_amt = request.getParameter("req_est_amt")==null?"":request.getParameter("req_est_amt");
	String amor_est_id = request.getParameter("amor_est_id")==null?"":request.getParameter("amor_est_id");
	
	if(c_id.equals("") && !car_mng_id.equals("")){
		m_id = rent_mng_id;
		l_cd = rent_l_cd;
		c_id = car_mng_id;
	}
	if(!c_id.equals("") && car_mng_id.equals("")){
		rent_mng_id	=m_id;
		rent_l_cd 	=l_cd;
		car_mng_id	=c_id;
	}	
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarServDatabase csd = CarServDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	PaySearchDatabase ps_db = PaySearchDatabase.getInstance();
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")){ 	user_id = login.getCookieValue(request, "acar_id"); }
	if(br_id.equals("")){	br_id = login.getCookieValue(request, "acar_br"); }
	if(auth_rw.equals("")){	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "03"); }
	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//�����ȸ
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
	//�Ҽ�	
	AccidSuitBean as_bean = as_db.getAccidSuitBean(c_id, accid_id);
	
	//��������
	String ins_st = ai_db.getInsStNow(c_id, a_bean.getAccid_dt());
	InsurBean ins = ai_db.getIns(c_id, ins_st);
	String ins_com_nm = ai_db.getInsComNm(c_id, ins_st);
	
	if(a_bean.getOur_ins().equals("")){
		a_bean.setOur_ins(ins_com_nm);
	}
	
	//������� ��������
	OtAccidBean oa_r [] = as_db.getOtAccid(c_id, accid_id);
	
	//�ڱ��ü���
	OneAccidBean oe_r [] = as_db.getOneAccid(c_id, accid_id);
	
	//����/����(��å��)
	ServiceBean s_r [] = as_db.getServiceList(c_id, accid_id);
	
	//����û����������Ʈ
	MyAccidBean my_r [] = as_db.getMyAccidList(c_id, accid_id);
	
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCaseAccid(c_id, accid_id);
	
	//������������
	//Hashtable reserv = rs_db.getCarInfo(rc_bean.getCar_mng_id());
	Vector reservs = rs_db.getResCarAccidList(c_id, accid_id);
	int reservs_size = reservs.size();
	
	String content_code = "PIC_ACCID";
	String content_seq  = c_id+""+accid_id;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();	
	
	Vector pay =  ps_db.getPayAccidResultList(c_id, accid_id);
	int pay_size = pay.size();
		
	 
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
	
	String car_st = String.valueOf(cont.get("CAR_NO"));
	if(car_st.length()>5 && !car_st.equals(""))	car_st = car_st.substring(4,5);	
	
	String accid_dt = a_bean.getAccid_dt();
	String accid_dt_h = "";
	String accid_dt_m = "";
	if(!accid_dt.equals("")){
		accid_dt = a_bean.getAccid_dt().substring(0,8);
		accid_dt_h = a_bean.getAccid_dt().substring(8,10);
		accid_dt_m = a_bean.getAccid_dt().substring(10,12);
	}
	
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettleCommi("45", car_mng_id+""+accid_id);
	String doc_no = doc.getDoc_no();
	
	//�����
	user_bean 	= umd.getUsersBean(doc.getUser_id1());

   int attach_serv_cnt = 0;  // ������ ��ϰ��� 
   int a_attach_serv_cnt = 0;  // ������ ���� ��ϰ��� ( �ѻ�� ��ü�� ������ ��� ) 
   
   int my_accid_cnt = 0;
   
   //���������� ��� �������� �Էµ������� ��������� - 20190909
   int  cls_serv_chk = 0;
   
   for(int i=0; i<s_r.length; i++){
	    s_bean3 = s_r[i];
		if ( s_bean3.getServ_st().equals("12") ) {
			 if ( Math.abs(a_bean.getOur_fault_per()-100) > 0  )  {
				 cls_serv_chk++;
			 }
		}
   }
   
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	var popObj = null;
	
	//��ϰ���
	function list(){
		var fm = document.form1;
		fm.target = 'd_content';
		if(fm.go_url.value == '')	fm.action = 'accid_result_frame.jsp';
		else						fm.action = fm.go_url.value;		
		fm.submit();
	}	

	//�����ϱ�
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;

		<% if(as_bean.getAccid_id() !=null && !as_bean.getAccid_id().equals("") && !as_bean.getSuit_type().equals("N")){ %>
			//�Ҽ��� �ִ°�� �Ҽ� ��>�������� ���� �������Է� - ��������� �ְ� �ǰ��� �� ��� �Ա��� �ȵǰ� ����ó�� ����(20210630)
			<%if(as_bean.getOur_fault_per() != 0){ %>
				<%if(as_bean.getJ_fault_per() == 0 ){ %>
					alert('�Ҽ� �ǿ��� �������� ������ ��� �Ǿ����� Ȯ���Ͻʽÿ�'); 
					return;
				<%} %>
			<%} %>
		
			<%if(as_bean.getMean_dt().equals("")){ %>
				alert('�Ҽ� �ǿ���  �ǰ����� ��� �Ǿ����� Ȯ���Ͻʽÿ�!'); 
				return;
	    	<%} %>
	    
			//�Ҽ��� �ִ°�� �Ҽ� ��>�Ա��� �������Է�
			<%//if(as_bean.getPay_dt().equals("")){ %>
				//alert('�Ҽ� �ǿ��� �������� ������ �Ա����� ��� �Ǿ����� Ȯ���Ͻʽÿ�!'); 
				//return;
		    <%//} %>		    
	
	<%}%>
		
		
	//	if(doc_bit == '1'){
		
		//����Ȯ������ 
			
			if(fm.pre_doc[0].checked == false ){
					alert("Ȯ������ �����ϼž� �մϴ�.!!");  //20170315���� - Ȯ���� �������� ������.
		//	if(fm.pre_doc[0].checked == false && fm.pre_doc[1].checked == false ){
		//		alert("����Ȯ�����θ� �����ϼž� �մϴ�.!!");
				return;
			}	
		//��������� �������� �ִٸ� ����ó�� ���ϰ�.	
		   <% if (cls_serv_chk > 0) { %>   
			alert("�������� �������� �ԷµǾ����ϴ�. �ٽ� Ȯ���ϼ���.!!");
			return;
		   <% } %>
		   
			if(fm.settle_dt.value == '')	{ alert('���ó�� �����Ȳ-�����������ڸ� �Է��Ͻʽÿ�.'); 				return; }
			if(fm.settle_id.value == '')	{ alert('���ó�� �����Ȳ-ó������ڸ� �Է��Ͻʽÿ�.'); 				return; }
			if(fm.settle_cont.value == '')	{ alert('���ó�� �����Ȳ-��Ÿ���� ������� ��Ȯ�� �Է��Ͻʽÿ�.'); 	return; }		
									
			if(toInt(fm.chk_cnt.value) > 0)	{ alert('��� ���������� '+fm.chk_cnt.value+'�� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.'); 	return; }			
	//	}
		
		//������Ȯ�� -20191226 
		<% if (attach_vt_size < 1) { %>   
			alert("�������� ��ϵ��� �ʴ� ���� ��û�ϼ̽��ϴ�.!!");		
		<% } %>
		
		//20200103 - �������, ������ check		
	  <% if ( a_bean.getAccid_st().equals("1") ) {//�����ΰ�� 
			if ( a_bean.getOur_fault_per() > 0) { %>
				alert('���ػ���ΰ�� ���Ǻ����� �߸��Ǿ����ϴ�. ��Ȯ�� �Է��Ͻʽÿ�.'); 
				return;
		<%	}
		} else if ( a_bean.getAccid_st().equals("2") ) {//�����ΰ�� 
			if ( a_bean.getOur_fault_per() <100) { %>
				alert('���ػ���ΰ�� ���Ǻ����� �߸��Ǿ����ϴ�. ��Ȯ�� �Է��Ͻʽÿ�.'); 
				return;
		<%	}
		} else if ( a_bean.getAccid_st().equals("3") ) {//�ֹ��ΰ�� 
			if ( a_bean.getOur_fault_per() < 1 ) {  %>
				alert('�ֹ����ΰ�� ���Ǻ����� �߸��Ǿ����ϴ�. ��Ȯ�� �Է��Ͻʽÿ�.'); 
				return;
		<%	}
	//	} else if ( a_bean.getAccid_st().equals("8") ) {//�ܵ��ΰ��   //���� ���� 
		} else  {//�ܵ��ΰ��   //���� ���� 
		
			if ( a_bean.getOur_fault_per() < 100) { %>
				alert('�ܵ�����ΰ�� ���Ǻ����� �߸��Ǿ����ϴ�. ��Ȯ�� �Է��Ͻʽÿ�.'); 
				return;
		<%	}
		} %>
		
		
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='accid_doc_sanction.jsp';		
			fm.target='i_no';
			fm.target='_blank';
			fm.submit();
		}									
	}
	
		
	//�ϴܸ޴� �̵�
	function sub_in(idx){
		window.open("/acar/accid/accid_u_in"+idx+".jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&mode="+idx+"&cmd=result", "VIEW_ACCID", "left=20, top=20, width=850, height=650, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	function view_client()
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=0", "VIEW_CLIENT", "left=20, top=20, width=820, height=700, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	function view_car()
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&cmd=ud", "VIEW_CAR", "left=20, top=20, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}
			
	function view_ins()
	{
		window.open("/acar/ins_mng/ins_u_frame.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&ins_st=<%=ins_st%>&cmd=view", "VIEW_INS", "left=20, top=20, width=850, height=650, resizable=yes, scrollbars=yes, status=yes");
	}		
		
	//�˾������� ���� - �������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	

	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='accid_u_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>

<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="rent_mng_id" value='<%=rent_mng_id%>'>
<input type='hidden' name="rent_l_cd" value='<%=rent_l_cd%>'>
<input type='hidden' name="car_mng_id" value='<%=car_mng_id%>'>
<input type='hidden' name="accid_id" value='<%=accid_id%>'>
<input type='hidden' name="mode" value='<%=mode%>'>
<input type='hidden' name="cmd" value='<%=cmd%>'>
<input type='hidden' name='go_url' value='<%=go_url%>'>  		

<input type='hidden' name="car_st" value='<%=cont.get("CAR_ST")%>'>
<input type='hidden' name="client_id" value='<%=cont.get("CLIENT_ID")%>'>
<input type='hidden' name="h_accid_dt" value=''>
<input type='hidden' name="accid_dt" value='<%=accid_dt%>'>
<input type='hidden' name="doc_no" 		value="<%=doc_no%>">
<input type='hidden' name="doc_bit" 	value="">
<input type='hidden' name="firm_nm" 	value="<%=cont.get("FIRM_NM")%>">
<input type='hidden' name="car_no" 		value="<%=cont.get("CAR_NO")%>">

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ >  <span class=style5>
						���ó���������</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  
    <tr>
		<td class=line2 colspan="2"></td>
	</tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="10%">����ȣ</td>
                    <td width="15%">&nbsp;<%=l_cd%></td>
                    <td class=title width="10%">��ȣ</td>
                    <td width="15%">&nbsp;<a href="javascript:view_client()"><%=cont.get("FIRM_NM")%></a><%if(String.valueOf(cont.get("USE_YN")).equals("N")){%>(����)<%}%></td>
                    <td class=title width="10%">�뵵����</td>
                    <td width="15%">&nbsp;
                  <%if(String.valueOf(cont.get("CAR_ST")).equals("1")){%>��Ʈ<%}else if(String.valueOf(cont.get("CAR_ST")).equals("3")){%>����<%}else if(String.valueOf(cont.get("CAR_ST")).equals("2")){%>������<%}%></td>
                    <td class=title width="10%">��������</td>
                    <td width="15%">&nbsp;<%=cont.get("RENT_WAY")%></td>
                </tr>
                <tr> 
                    <td class=title>������ȣ</td>
                    <td>&nbsp;<a href="javascript:view_car()"><%=cont.get("CAR_NO")%></a></td>
                    <td class=title>����</td>
                    <td>&nbsp;<%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%></td>
                    <td class=title>���������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(cont.get("INIT_REG_DT")))%></td>
                    <td class=title>���������</td>
                    <td>&nbsp;<%=cont.get("USER_NM")%></td>
                </tr>
                <tr> 
                    <td class=title>����ȸ��</td>
                    <td>&nbsp;<a href="javascript:view_ins()"><%=ins_com_nm%></a>
        			<%if(ins.getVins_spe().equals("�ִ�ī")){%>(�ִ�ī)<%}%>
        			</td>
                    <td class=title>�Ǻ�����</td>
                    <td>&nbsp;
                        <%if(ins.getCon_f_nm().equals("�Ƹ���ī")){%>
                        <%=ins.getCon_f_nm()%>
                        <%}else{%>
                        <b><font color='#990000'><%=ins.getCon_f_nm()%></font></b>
                        <%}%></td>
                    <td class=title>����Ⱓ</td>						
                    <td>&nbsp;
						<%=AddUtil.ChangeDate2(ins.getIns_start_dt())%>~<%=AddUtil.ChangeDate2(ins.getIns_exp_dt())%>  
                    </td>
                    <td class=title>�ڱ���������</td>
                    <td>&nbsp;
                      <%if(ins.getVins_cacdt_cm_amt()>0){%>
                      <b><font color='#990000'> ���� ( ���� <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>����, �ڱ�δ�� <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>����) </font></b>
                      <%}else{%>
-
<%}%>
        			</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
		<td class=h></td>
	</tr> 
    <%if(!a_bean.getRent_s_cd().equals("") && String.valueOf(cont.get("CAR_ST")).equals("2")){
			//�ܱ�������
			RentContBean rc_bean2 = rs_db.getRentContCase2(a_bean.getRent_s_cd());
	%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����������</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>�뿩����</td>
                    <td width=15%>&nbsp; 
                      <%String sub_rent_gu = "";
        				if(a_bean.getSub_rent_gu().equals("1")){ 	sub_rent_gu="�ܱ�뿩"; }
        				if(a_bean.getSub_rent_gu().equals("2")){ 	sub_rent_gu="�������"; }
        				if(a_bean.getSub_rent_gu().equals("3")){ 	sub_rent_gu="������"; }
        				if(a_bean.getSub_rent_gu().equals("9")){ 	sub_rent_gu="�������"; }
        				if(a_bean.getSub_rent_gu().equals("10")){ 	sub_rent_gu="��������"; }
        				if(a_bean.getSub_rent_gu().equals("4")){ 	sub_rent_gu="�����뿩"; }
        				if(a_bean.getSub_rent_gu().equals("5")){ 	sub_rent_gu="��������"; }
        				if(a_bean.getSub_rent_gu().equals("6")){ 	sub_rent_gu="��������"; }
        				if(a_bean.getSub_rent_gu().equals("7")){ 	sub_rent_gu="��������"; }
        				if(a_bean.getSub_rent_gu().equals("8")){ 	sub_rent_gu="������"; }
        				if(a_bean.getSub_rent_gu().equals("12")){ 	sub_rent_gu="����Ʈ"; }
        				if(a_bean.getSub_rent_gu().equals("99")){ 	sub_rent_gu="��Ÿ"; }
        				%>
                      <%=sub_rent_gu%>                     
                  </td>
                    <td class=title width=10%>��ȣ</td>
                    <td width=15%>&nbsp; 
                      <%=a_bean.getSub_firm_nm()%>
                  </td>
                    <td class=title width=10%>���Ⱓ</td>
                    <td width=40%>&nbsp; 
                      <%=AddUtil.ChangeDate2(a_bean.getSub_rent_st())%>
                      ~ 
                      <%=AddUtil.ChangeDate2(a_bean.getSub_rent_et())%>
                  </td>
                </tr>
                <tr> 
                    <td class=title>�޸�</td>
                    <td colspan="5">&nbsp;
                      <%=a_bean.getMemo()%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
		<td class=h></td>
	</tr> 
    <%}%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����</span></td>
        <td align="right"> 
        <a href='javascript:list()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_list.gif"  align="absmiddle" border="0"></a> 		
        </td>
    </tr>
    <tr>
		<td class=line2 colspan=2></td>
	</tr> 
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>������ȣ</td>
                    <td width=15%>&nbsp; 
                      <%=c_id%>-<%=accid_id%>
                    </td>
                    <td class=title width=10%>�������</td>
                    <td width=15%>&nbsp;
                      <%if(a_bean.getAccid_st().equals("1")){%>����<%}%>
                      <%if(a_bean.getAccid_st().equals("2")){%>����<%}%>
                      <%if(a_bean.getAccid_st().equals("3")){%>�ֹ�<%}%>
                      <%if(a_bean.getAccid_st().equals("5")){%>�������<%}%>
                      <%if(a_bean.getAccid_st().equals("4")){%>��������<%}%>
                      <%if(a_bean.getAccid_st().equals("6")){%>����<%}%>
		  <%if(a_bean.getAccid_st().equals("7")){%>�縮������<%}%>
		   <%if(a_bean.getAccid_st().equals("8")){%>�ܵ�<%}%>
                    </td>
					<td class=title width=10%>�߻��Ͻ�</td>
                    <td width=15%>&nbsp; 
                      &nbsp;<%=AddUtil.ChangeDate3(a_bean.getAccid_dt())%>
                    </td>
					<td class=title width=10%>�����Ͻ�</td>
                    <td width=15%>&nbsp; 
                      &nbsp;<%=AddUtil.ChangeDate2(a_bean.getReg_dt())%>
                    </td>										
                </tr>
                <tr>
                  <td class=title>������</td>
                  <td colspan="7">&nbsp;
				    <%if(a_bean.getAccid_type_sub().equals("1")){%>[���Ϸ�]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("2")){%>[������]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("3")){%>[ö��ǳθ�]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("4")){%>[Ŀ���]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("5")){%>[����]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("6")){%>[������]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("7")){%>[����]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("8")){%>[��Ÿ]<%}%>
					<%if(!a_bean.getAccid_type_sub().equals("")){%>&nbsp;<%}%>
                    <%=a_bean.getAccid_addr()%></td>
                </tr>
                <tr>
                  <td class=title>������</td>
                  <td colspan="7">&nbsp;
				    <%=a_bean.getAccid_cont()%>
					<%if(!a_bean.getAccid_cont2().equals("") && !a_bean.getAccid_cont().equals(a_bean.getAccid_cont2())){%>
					<br>&nbsp;
					<%=a_bean.getAccid_cont2()%>
					<%}%>
				  </td>
                </tr>
                <tr>
                  <td class=title>���Ǻ���</td>
                  <td >&nbsp;
				    &nbsp;��� 
                      <%=a_bean.getOur_fault_per()%>
                      : 
                      <%=Math.abs(a_bean.getOur_fault_per()-100)%>
                      ����
				  </td>
				   <td class=title>&nbsp;&nbsp; <font  color=red> * ����Ȯ������ </font></td>  
				   <td colspan="5">&nbsp;&nbsp;
				   	  <input type="radio" name="pre_doc" value="Y"  <% if(a_bean.getPre_doc().equals("Y")){ out.print("checked"); }%> > Ȯ�� &nbsp;
					  &nbsp;<input type="radio" name="pre_doc" value="P"  <% if(a_bean.getPre_doc().equals("P")){ out.print("checked"); }%> > ��Ȯ�� &nbsp;
				   </td>				  	  
				  
                </tr>   
                      
                             
                <tr>
                  <td class=title>Ư�̻���</td>
                  <td colspan="7">&nbsp;
				    <%=a_bean.getSub_etc()%>
				  </td>
                </tr>				
            </table>
        </td>
    </tr>
    <tr>
		<td class=h></td>
	</tr> 
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������/����</span></td>
        <td align="right">&nbsp;  </td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;<font color=red>1. �������</font></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>�����ڸ�</td>
                    <td width=15%> 
                      <%=a_bean.getOur_driver()%>
                    </td>
                    <td class=title width=10%>�������</td>
                    <td width=15%> 
                      <%=AddUtil.ChangeEnpH(a_bean.getOur_ssn())%>
                    </td>
                    <td class=title width=10%>�����ȣ</td>
                    <td width=15%> 
                      <%=a_bean.getOur_lic_no()%>
                    </td>
                    <td class=title width=10%>��������</td>
                    <td width=15%> 
                      <%=a_bean.getOur_lic_kd()%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ȿ�Ⱓ</td>
                    <td> 
                      <%=AddUtil.ChangeDate2(a_bean.getOur_lic_dt())%>
                    </td>
                    <td class=title>�޴���</td>
                    <td> 
                      <%=a_bean.getOur_m_tel()%>
                    </td>
                    <td class=title>����ó��</td>
                    <td> 
                      <%=a_bean.getOur_tel()%>
                    </td>
                    <td class=title>����ó��</td>
                    <td> 
                      <%=a_bean.getOur_tel2()%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>				
                <tr> 
                    <td class=title width=10%>������</td>
                    <td width=15%> 					  
                      <%=a_bean.getOur_ins()%>
                    </td>
                    <td class=title width=10%>��������NO</td>
                    <td width=15%> 
                      <%=a_bean.getOur_num()%>
                    </td>
                    <td class=title width=10%>���ع߻�</td>
                    <td width=15%> 
                      <%if(a_bean.getOur_dam_st().equals("")){%>����<%}%>
                      <%if(a_bean.getOur_dam_st().equals("1")){%>����<%}%>
                      <%if(a_bean.getOur_dam_st().equals("2")){%>�빰<%}%>
                      <%if(a_bean.getOur_dam_st().equals("3")){%>����+�빰<%}%>
                    </td>
                    <td class=title width=10%>���Ǻ���</td>
                    <td width=15%> 
                      <%=a_bean.getOur_fault_per()%>%
                    </td>			
                </tr>
                <tr> 
                    <td class=title>���δ���ڸ�</td>
                    <td> 
                      <%=a_bean.getHum_nm()%>
                    </td>
                    <td class=title>����ó</td>
                    <td> 
                      <%=a_bean.getHum_tel()%>
                    </td>		  
                    <td class=title>�빰����ڸ�</td>
                    <td> 
                      <%=a_bean.getMat_nm()%>
                    </td>
                    <td class=title>����ó</td>
                    <td> 
                      <%=a_bean.getMat_tel()%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%if(a_bean.getAccid_st().equals("1") || a_bean.getAccid_st().equals("2") || a_bean.getAccid_st().equals("3")){//����,����,�ֹ�%>
    <%	if(oa_r.length > 0){
			for(int i=0; i<oa_r.length; i++){
    			oa_bean = oa_r[i];%>	
    <tr> 
        <td>&nbsp;&nbsp;<font color=red><%=i+2%>. �������(<%=i+1%>)</font></td>
        <td align="right">&nbsp; </td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
            	    <td class=line2 colspan=2 style='height:1'></td>
            	</tR>
                <tr> 
                    <td class=title width=10%>�����ڸ�</td>
                    <td width=15%> 
                      <%=oa_bean.getOt_driver()%>
                    </td>
                    <td class=title width=10%>�������</td>
                    <td width=15%> 
                      <%=AddUtil.ChangeEnpH(oa_bean.getOt_ssn())%>
                    </td>
                    <td class=title width=10%>�����ȣ</td>
                    <td width=15%> 
                      <%=oa_bean.getOt_lic_no()%>
                    </td>
                    <td class=title width=10%>��������</td>
                    <td width=15%> 
                      <%=oa_bean.getOt_lic_kd()%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ȣ</td>
                    <td> 
                      <%=oa_bean.getOt_car_no()%>
                    </td>
                    <td class=title>����</td>
                    <td> 
                      <%=oa_bean.getOt_car_nm()%>
                    </td>
                    <td class=title>�޴���</td>
                    <td> 
                      <%=oa_bean.getOt_m_tel()%>
                    </td>
                    <td class=title>����ó</td>
                    <td> 
                      <%=oa_bean.getOt_tel()%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>								
                <tr> 
                    <td class=title width=10%>������</td>
                    <td>
					  <%=oa_bean.getOt_ins()%>
                    </td>
                    <td class=title width=10%>��������NO</td>
                    <td> 
                      <%=oa_bean.getOt_num()%>
                    </td>
                    <td class=title>���ع߻�</td>
                    <td> 
                      <%if(oa_bean.getOt_dam_st().equals("")){%>  ����<%}%>
                      <%if(oa_bean.getOt_dam_st().equals("1")){%> ����<%}%>
                      <%if(oa_bean.getOt_dam_st().equals("2")){%> �빰<%}%>
                      <%if(oa_bean.getOt_dam_st().equals("3")){%> ����+�빰<%}%>
                    </td>
                    <td class=title>���Ǻ���</td>
                    <td> 
                      <%=oa_bean.getOt_fault_per()%>%
                    </td>				
                </tr>
                <tr> 
                    <td class=title width=10%>���δ���ڸ�</td>
                    <td width=15%> 
                      <%=oa_bean.getHum_nm()%>
                    </td>
                    <td class=title width=10%>����ó</td>
                    <td width=15%> 
                      <%=oa_bean.getHum_tel()%>
                    </td>		  
                    <td class=title width=10%>�빰����ڸ�</td>
                    <td width=15%> 
                      <%=oa_bean.getMat_nm()%>
                    </td>
                    <td class=title width=10%>����ó</td>
                    <td width=15%> 
                      <%=oa_bean.getMat_tel()%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
		<td class=h></td>
	</tr> 	
	<%		}
		}else{%>
    <tr> 
        <td>&nbsp;&nbsp;<font color=red>2. �������</font></td>
        <td align="right">&nbsp; </td>
    </tr>		
    <tr> 
        <td colspan="2">����Ÿ�� �����ϴ�.</td>
    </tr>					
	<%	}%>	
	<%}%>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ػ�Ȳ</span></td>
        <td align="right"> 
        </td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;<font color=red>1. ���ر���</font></td>
        <td align="right">&nbsp;</td>
    </tr>		
    <tr>
		<td class=line2 colspan=2></td>
	</tr> 
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>����</td>
                    <td width=15%>&nbsp; 
                      <%if(a_bean.getDam_type1().equals("Y")){%><b><font color='#990000'>����</font></b><%}else{%>����<%}%>
                    </td>
                    <td class=title width=10%>�빰</td>
                    <td width=15%>&nbsp;
					  <%if(a_bean.getDam_type2().equals("Y")){%><b><font color='#990000'>����</font></b><%}else{%>����<%}%>
                    </td>
					<td class=title width=10%>�ڼ�</td>
                    <td width=15%>&nbsp; 
                      <%if(a_bean.getDam_type3().equals("Y")){%><b><font color='#990000'>����</font></b><%}else{%>����<%}%>
                    </td>
					<td class=title width=10%>����</td>
                    <td width=15%>&nbsp; 
                      <%if(a_bean.getDam_type4().equals("Y")){%><b><font color='#990000'>����</font></b><%}else{%>����<%}%>
                    </td>										
                </tr>
            </table>
        </td>
    </tr>	
    <tr>
		<td class=h></td>
	</tr> 
    <tr> 
        <td>&nbsp;&nbsp;<font color=red>2. �������</font></td>
        <td align="right">&nbsp;</td>
    </tr>		
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width="4%" rowspan="2" class=title>����</td>
                    <td width="6%" rowspan="2" class=title>����</td>
                    <td width="5%" rowspan="2" class=title>�λ�����</td>
                    <td colspan="5" class=title>������</td>
                    <td colspan="3" class=title>����</td>
                </tr>
                <tr>
                  <td width="10%" class=title>����</td>
                  <td width="5%" class=title>����</td>
                  <td width="5%" class=title>����</td>
                  <td width="10%" class=title>����</td>
                  <td width="10%" class=title>����ó</td>
                  <td width="15%" class=title>������</td>
                  <td width="10%" class=title>����ó</td>
                  <td width="20%" class=title>���ܳ���</td>
                </tr>
          		<%	for(int i=0; i<oe_r.length; i++){
    					oe_bean = oe_r[i];%>
                <tr> 
                    <td align="center"> 
                      <%=oe_bean.getSeq_no()%>
                    </td>
                    <td align="center"> 
                      <%if(oe_bean.getOne_accid_st().equals("1")){%>�ڼ�<%}%>
        			  <%if(oe_bean.getOne_accid_st().equals("2")){%>����<%}%>
					  &nbsp;
				    </td>
                    <td align="center">
					  <%if(oe_bean.getWound_st().equals("1")){%>���<%}%>
					  <%if(oe_bean.getWound_st().equals("2")){%>�߻�<%}%>
					  <%if(oe_bean.getWound_st().equals("3")){%>���<%}%></td>
                    <td align="center"> 
                      <%=oe_bean.getNm()%>
                    </td>
                    <td align="center"> 
                      <%if(oe_bean.getSex().equals("1")){%>��<%}%>
                      <%if(oe_bean.getSex().equals("2")){%>��<%}%>
                    </td>
                    <td align="center"> 
                      <%=oe_bean.getAge()%>��</td>
                    <td align="center"> 
                      <%=oe_bean.getRelation()%>
                    </td>
                    <td align="center"> 
                      <%=oe_bean.getTel()%>
                    </td>
                    <td align="center"> 
                      <%=oe_bean.getHosp()%>
                    </td>
                    <td align="center"> 
                      <%=oe_bean.getHosp_tel()%>
                    </td>
                    <td align="center"> 
                      <%=oe_bean.getDiagnosis()%>
                    </td>
                </tr>
          		<%	}%>
				<%	if(oe_r.length==0){%>
				<tr>
				  <td colspan='11' align="center">����Ÿ�� �����ϴ�.</td>
				</tr>
				<%	}%>
            </table>
        </td>
    </tr>	
    <tr>
		<td class=h></td>
	</tr> 
    <tr> 
        <td>&nbsp;&nbsp;<font color=red>3. �������</font></td>
        <td align="right">
			<%if(attach_vt_size > 0){%>
			<br>
			<a class=index1 href="javascript:MM_openBrWindow('/acar/accid_mng/attach_big_imgs2.jsp?content_code=<%=content_code%>&content_seq=<%=content_seq%>&seq=','popwin0','scrollbars=yes,status=yes,resizable=yes,width=660,height=608,left=50, top=50')" title='������ ����'>			
				[���� <%=attach_vt_size%>��]
			</a>
			<%}%>
						
		</td>
    </tr>		
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="4%">����</td>
                    <td class=title width="11%">����</td>
                    <td class=title width="10%">��������</td>
                    <td class=title width="15%">�����ü��</td>
                    <td class=title width="10%">����ó</td>
                    <td class=title width="10%">�ѽ���ȣ</td>
                    <td class=title width="10%">����ݾ�</td>
                    <td class=title width="25%">���񳻿�</td>
                    <td class=title width="5%">������</td>
                </tr>
              	<%	int s_cnt = 0;
					for(int i=0; i<s_r.length; i++){
        				s_bean = s_r[i];
						s_cnt++;
						
						ServItem2Bean si_r [] = csd.getServItem2All(s_bean.getCar_mng_id(), s_bean.getServ_id());
						String f_item = "";
						String a_item = "";
						for(int j=0; j<si_r.length; j++){
 							si_bean = si_r[j];
							if(j==0) f_item = si_bean.getItem();
							if(j==si_r.length-1){
        				    	a_item += si_bean.getItem();
        				    }else{
        				    	a_item += si_bean.getItem()+",";
        				    }
        				}
					
						
			//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
		
	
			content_code = "SERVICE";
			content_seq  = s_bean.getCar_mng_id()+""+s_bean.getServ_id();

			attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
			attach_vt_size = attach_vt.size();	
			
			attach_serv_cnt = attach_vt.size();		
			
			a_attach_serv_cnt += attach_serv_cnt;		
						%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center">
                        <%if(s_bean.getServ_st().equals("7")){%>�縮������
                    	<%}else if(s_bean.getServ_st().equals("4")){%>��������
                    	<%}else if(s_bean.getServ_st().equals("5")){%>�������                    	
                    	<%}else if(s_bean.getServ_st().equals("12")){%>��������
                    	<%}else if(s_bean.getServ_st().equals("13")){%>����
                    	<%}else{%>&nbsp;
                    	<%}%>  
                    </td>					
                    <td align="center"><%=AddUtil.ChangeDate2(s_bean.getServ_dt())%></td>
                    <td align="center"><%=s_bean.getOff_nm()%></td>
                    <td align="center"><%=s_bean.getOff_tel()%></td>
                    <td align="center"><%=s_bean.getOff_fax()%></td>
                    <td align="right">
                                 <%=AddUtil.parseDecimal(s_bean.getRep_amt())%>��
                                 <!--
		                 <% if ( s_bean.getR_j_amt() > 0) { %>  
        		         <%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf((s_bean.getR_labor()+s_bean.getR_j_amt())* 1.1)))%>��
		                 <% } else { %>   
        		         <%=AddUtil.parseDecimal(s_bean.getTot_amt())%>��
                		 <% } %>
                		 -->
	                </td>
                    <td>
					<%	if(!a_item.equals("")){%>
					<span title="<%=a_item%>">&nbsp;<%=f_item%><% if(si_r.length>1){ %>�� <font color="red"><%=si_r.length-1%></font>�� <% } %></span>								
					<%	}else{%>
					<span title="<%=s_bean.getRep_cont()%>">&nbsp;<%=Util.subData(s_bean.getRep_cont(),15)%></span>
					<%	}%> 
					<!-- �������ķ���ο��� ��¥�и��� ������ �� ���� ��û������ ���� ���� -->  
                    <% if ( !s_bean.getRep_cont().equals("��å�� ��û����") ) { %>
	        			<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	        			<a href="javascript:MM_openBrWindow('/acar/cus_reg/serv_reg.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>&serv_id=<%=s_bean.getServ_id()%>&cmd=4','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=700,top=20,left=20')"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
	        			<%}%>
	        		<% } %>
					</td>
                    <td align="center">        			
        			<%if(attach_vt_size > 0){%>
			    <%	for (int j = 0 ; j < attach_vt_size ; j++){
    					Hashtable ht = (Hashtable)attach_vt.elementAt(j);%>
    					&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
    					&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    					<%if(j+1 < attach_vt_size){%><br><%}%>
    			    <%	}%>		
        		<%}%>        		
        		
					</td>
                </tr>
              	<%	}%>
			  	<%	if(a_bean.getAccid_st().equals("2") || a_bean.getAccid_st().equals("3")){//����,�ֹ�%>
			  	<%		for(int i=0; i<oa_r.length; i++){
        					oa_bean = oa_r[i];
							if(!oa_bean.getOff_nm().equals("") || oa_bean.getServ_amt()>0 || a_bean.getDam_type2().equals("Y")){
								s_cnt++;%>
                <tr> 							
                    <td align="center"><%=s_r.length+i+1%></td>
                    <td align="center">�빰<%=oa_bean.getSeq_no()%> <%=oa_bean.getOt_car_no()%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(oa_bean.getServ_dt())%></td>
                    <td align="center"><%=oa_bean.getOff_nm()%></td>
                    <td align="center"><%=oa_bean.getOff_tel()%></td>
                    <td align="center"><%=oa_bean.getOff_fax()%></td>
                    <td align="right"><%=AddUtil.parseDecimal(oa_bean.getServ_amt())%>��</td>
                    <td align="center"><%=oa_bean.getServ_cont()%></td>
                    <td align="center"></td>
                </tr>	
				<%			}%>				  					
			  	<%		}%>				
			  	<%	}%>
				<%	if(s_cnt==0){%>
				<tr>
				  <td colspan='9' align="center">����Ÿ�� �����ϴ�.</td>
				</tr>
				<%	}%>			  
            </table>
        </td>
    </tr>
    <tr>
		<td class=h></td>
	</tr> 
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�δ����</span></td>
        <td align="right"> 
        </td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;<font color=red>1. ��������</font></td>
        <td align="right">&nbsp;</td>
    </tr>	
	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>		
    <tr> 
        <td class=line colspan="2">
            <table border="0" cellspacing="1" width=100%>
            <%if(reservs_size > 0){%>
            <%	for(int i = 0 ; i < reservs_size ; i++){
            	Hashtable reserv = (Hashtable)reservs.elementAt(i);
            	
            %>
                <tr> 
                    <td class=title width=10%>������ȣ</td>
                    <td width=10%>&nbsp;<%=reserv.get("CAR_NO")%></td>
                    <td class=title width=10%>����</td>
                    <td width=20%>&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;</td>
                    <td class=title width=10%>�����Ͻ�</td>
                    <td width=15%>&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("DELI_DT")))%></td>
                    <td class=title width=10%>�����Ͻ�</td>
                    <td width=15%>&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RET_DT")))%></td>
                </tr>
                <%	}%>
	<%}else{%>
      <tr> 
          <td class=title width=10%>������ȣ</td>
          <td width=10%>&nbsp;������������</td>
          <td class=title width=10%>����</td>
          <td width=20%>&nbsp;</td>
          <td class=title width=10%>�����Ͻ�</td>
          <td width=15%>&nbsp;</td>
          <td class=title width=10%>�����Ͻ�</td>
          <td width=15%>&nbsp;</td>
      </tr>				
	<%}%>
         </table>
        </td>
    </tr>
    <tr>
		<td class=h></td>
	</tr> 	
    <tr> 
        <td>&nbsp;&nbsp;<font color=red>2. ������û��</font></td>
        <td align="right">&nbsp;</td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>		
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width="4%" rowspan="2" class=title>����</td>
                    <td width="5%" rowspan="2" class=title>����</td>
                    <td width="4%" rowspan="2" class=title>���<br>����</td>
                    <td colspan="2" class=title>�����</td>
                    <td colspan="2" class=title>��������</td>
                    <td colspan="3" class=title>û��</td>
                    <td colspan="2" class=title>�Ա�</td>
					<td width="4%" rowspan="2" class=title>��û��<br>����</td>	
                </tr>
                <tr>
                  <td width="15%" class=title>��ȣ</td>
                  <td width="5%" class=title>�����</td>
                  <td width="9%" class=title>������ȣ</td>
                  <td width="10%" class=title>����</td>
                  <td width="15%" class=title>�����Ⱓ</td>
                  <td width="7%" class=title>�ݾ�</td>
                  <td width="7%" class=title>����</td>
                  <td width="7%" class=title>�ݾ�</td>
                  <td width="7%" class=title>����</td>
                </tr>
				<%	int tot_my_req_amt = 0;
					int tot_my_pay_amt = 0;
					for(int i=0; i<my_r.length; i++){
    					my_bean2 = my_r[i];
						//�޴����� ���ݽ�����
						Hashtable ext6 = a_db.getScdExtEtcPay(m_id, l_cd, "6", accid_id+""+my_bean2.getSeq_no());
						if(AddUtil.parseInt(String.valueOf(ext6.get("PAY_AMT")))>0){
							my_bean2.setIns_pay_amt(AddUtil.parseInt(String.valueOf(ext6.get("PAY_AMT"))));
						}
						tot_my_req_amt += my_bean2.getIns_req_amt();
						tot_my_pay_amt += my_bean2.getIns_pay_amt();
										
					   if (  Math.abs(a_bean.getOur_fault_per()-100) !=  my_bean2.getOt_fault_per() ) {  //��� �������� ��/������ �������� ���̰� �ִ� ��� �˸� - 20181015
						  my_accid_cnt  += 1;
						}
						
						%>
                <tr>
                  <td align="center"><%=i+1%></td>
                  <td align="center"><%if(my_bean2.getIns_req_gu().equals("2")){%>������<%}%><%if(my_bean2.getIns_req_gu().equals("1")){%>������<%}%></td>
                  <td align="center"><%=my_bean2.getOt_fault_per()%></td>
                  <td align="center"><%=my_bean2.getIns_com()%></td>
                  <td align="center"><%=my_bean2.getIns_nm()%></td>
                  <td align="center"><%=my_bean2.getIns_car_no()%></td>
                  <td align="center"><%=my_bean2.getIns_car_nm()%></td>
                  <td align="center"><%=AddUtil.ChangeDate3(my_bean2.getIns_use_st())%>~<%=AddUtil.ChangeDate3(my_bean2.getIns_use_et())%></td>
                  <td align="right"><%=AddUtil.parseDecimal(my_bean2.getIns_req_amt())%>��</td>
                  <td align="center"><%=AddUtil.ChangeDate2(my_bean2.getIns_req_dt())%></td>
                  <td align="right"><%=AddUtil.parseDecimal(my_bean2.getIns_pay_amt())%>��</td>
                  <td align="center"><%=AddUtil.ChangeDate2(my_bean2.getIns_pay_dt())%></td>
		  <td align="center"><span title="��û������:<%=my_bean2.getRe_reason()%>"><%if(my_bean2.getIns_req_st().equals("0") && !my_bean2.getRe_reason().equals("")){//��û��%>��û��<%}%></span></td>					
                </tr>
				<%	}%>
				<%	if(my_r.length==0){%>
				<tr>
				  <td colspan='13' align="center">����Ÿ�� �����ϴ�.</td>
				</tr>
				<%	}%>		
			</table>
		</td>
    </tr>		
    <tr>
		<td class=h></td>
	</tr> 	
    <tr> 
        <td>&nbsp;&nbsp;<font color=red>3. ��å��û��</font>
		&nbsp;&nbsp;&nbsp;&nbsp;(���谡�Ը�å�� : <%=AddUtil.parseDecimal(String.valueOf(cont.get("CAR_JA")))%>��)
		</td>
        <td align="right">&nbsp;</td>
    </tr>		
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width="4%" rowspan="2" class=title>����</td>
                    <td colspan="3" class=title>�������</td>
                    <td colspan="2" class=title>û��</td>
                    <td colspan="2" class=title>�Ա�</td>
                    <td width="9%" rowspan="2" class=title>��<br>�Աݾ�</td>
                    <td width="9%" rowspan="2" class=title>��������<br>�ñݾ�</td>
                    <td width="4%" rowspan="2" class=title>����<br>����</td>					
                </tr>
                <tr>
                  <td width="10%" class=title>��������</td>
                  <td width="14%" class=title>�����ü��</td>
                  <td width="10%" class=title>����ݾ�</td>
                  <td width="10%" class=title>�ݾ�</td>
                  <td width="10%" class=title>����</td>
                  <td width="10%" class=title>�ݾ�</td>
                  <td width="10%" class=title>����</td>
                </tr>
              	<%	int tot_sv_amt = 0;
					int tot_sv_req_amt = 0;
					int tot_sv_pay_amt = 0;
					int tot_accid_amt = 0;
					for(int i=0; i<s_r.length; i++){
        				s_bean2 = s_r[i];
						if(!s_bean2.getNo_dft_yn().equals("Y") && !s_bean2.getServ_st().equals("7")){ //�縮�� 
							tot_sv_amt 		+= s_bean2.getTot_amt();
						}
						
						tot_accid_amt 	+= s_bean2.getTot_amt();
						tot_sv_req_amt 	+= s_bean2.getCust_amt();
						tot_sv_pay_amt 	+= s_bean2.getExt_amt();
						if(s_bean2.getDly_amt()>0){
							tot_sv_req_amt  += s_bean2.getDly_amt();
							tot_sv_pay_amt 	+= s_bean2.getDly_amt();
						}
						if(s_bean2.getCls_amt()>0){
							tot_sv_req_amt  += s_bean2.getCls_amt();
							tot_sv_pay_amt 	+= s_bean2.getCls_amt();
						}
						%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(s_bean2.getServ_dt())%></td>
                    <td align="center"><%=s_bean2.getOff_nm()%></td>
                    <td align="right"><%=AddUtil.parseDecimal(s_bean2.getRep_amt())%>��
                         <!--
                         <% if ( s_bean2.getR_j_amt() > 0) { %>  
	                 <%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf((s_bean2.getR_labor()+s_bean2.getR_j_amt())* 1.1)))%>��
	                 <% } else { %>   
	                 <%=AddUtil.parseDecimal(s_bean2.getTot_amt())%>
	                 <% } %>
	                 -->
                    </td> 
                    <td align="right"><%=AddUtil.parseDecimal(s_bean2.getCust_amt())%>��</td>
                    <td align="center"><%=AddUtil.ChangeDate2(s_bean2.getCust_req_dt())%></td>
                    <td align="right"><%=AddUtil.parseDecimal(s_bean2.getExt_amt())%>��</td>
                    <td align="center"><%=AddUtil.ChangeDate2(s_bean2.getCust_pay_dt())%></td>
		    <td align="right"><%=AddUtil.parseDecimal(s_bean2.getDly_amt())%>��</td>
		    <td align="right"><%=AddUtil.parseDecimal(s_bean2.getCls_amt())%>��</td>
		    <td align="center"><span title="��������:<%=s_bean2.getNo_dft_cau()%>"><%if(s_bean2.getNo_dft_yn().equals("Y")){//��û��%>����<%}%></span></td>					
                </tr>
              	<%	}%>									
				<%	if(s_r.length==0){%>
				<tr>
				  <td colspan='11' align="center">����Ÿ�� �����ϴ�.</td>
				</tr>
				<%	}%>						
            </table>
        </td>
    </tr>	
    <tr>
		<td class=h></td>
	</tr> 		
	<%	if(pay_size>0){%>	
    <tr> 
        <td>&nbsp;&nbsp;<font color=red>4. ���ػ��ΰ��� ���ó����</font></td>
        <td align="right">&nbsp;</td>
    </tr>		
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
                  <td width="4%" height="31" class=title>����</td>
                  <td width="16%" class=title>����</td>
                  <td width="18%" class=title>����ó</td>
                  <td width="10%" class=title>�ŷ�����</td>
                  <td width="10%" class=title>��������</td>				  
                  <td width="10%" class=title>����ݾ�</td>
                  <td width="32%" class=title>����</td>
                </tr>
              	<%	for(int i = 0 ; i < pay_size ; i++){
						Hashtable ht = (Hashtable)pay.elementAt(i);%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ht.get("P_ST2")%></td>
                    <td align="center"><%=ht.get("OFF_NM")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("P_EST_DT")))%></td> 
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("P_PAY_DT")))%></td> 					
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("I_AMT")))%>��</td>
                    <td>&nbsp;<%=ht.get("P_CONT")%></td>
                </tr>
              	<%	}%>									
            </table>
        </td>
    </tr>	
    <tr>
		<td class=h></td>
	</tr> 		
	<%	}%>			
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ó�����</span></td>
        <td align="right"> 
        </td>
    </tr>
	<tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title colspan="2">����</td>
                    <td class=title colspan="2">����ݾ�</td>
                    <td class=title width=15%>����Ϸ���</td>
                    <td class=title width=20%>�����</td>
                    <td class=title width=15%>����ó</td>
                </tr>
                <tr> 
                    <td class=title rowspan="4" width=10%>�����</td>
                    <td class=title width=10%>����</td>
                    <td align="right" width=15%> 
                      <%=AddUtil.parseDecimal(a_bean.getHum_amt())%>��</td>
                    <td align="right" rowspan="4" width=15%> 
                      <%=AddUtil.parseDecimal(a_bean.getEx_tot_amt())%>��</td>
                    <td align="center"> 
                      <%=AddUtil.ChangeDate2(a_bean.getHum_end_dt())%></td>
                    <td align="center"> 
                      <%=AddUtil.ChangeDate2(a_bean.getHum_nm())%></td>
                    <td align="center"> 
                      <%=AddUtil.ChangeDate2(a_bean.getHum_tel())%></td>
                </tr>
                <tr> 
                    <td class=title>�빰</td>
                    <td align="right"> 
                      <%=AddUtil.parseDecimal(a_bean.getMat_amt())%>��</td>
                    <td align="center"> 
                      <%=AddUtil.ChangeDate2(a_bean.getMat_end_dt())%></td>
                    <td align="center"> 
                      <%=AddUtil.ChangeDate2(a_bean.getMat_nm())%></td>
                    <td align="center"> 
                      <%=AddUtil.ChangeDate2(a_bean.getMat_tel())%></td>
                </tr>
                <tr> 
                    <td class=title>�ڼ�</td>
                    <td align="right"> 
                      <%=AddUtil.parseDecimal(a_bean.getOne_amt())%>��</td>
                    <td align="center"> 
                      <%=AddUtil.ChangeDate2(a_bean.getOne_end_dt())%></td>
                    <td align="center"> 
                      <%=AddUtil.ChangeDate2(a_bean.getOne_nm())%></td>
                    <td align="center"> 
                      <%=AddUtil.ChangeDate2(a_bean.getOne_tel())%></td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td align="right"> 
                      <%=AddUtil.parseDecimal(a_bean.getMy_amt())%>��</td>
                    <td align="center"> 
                      <%=AddUtil.ChangeDate2(a_bean.getMy_end_dt())%></td>
                    <td align="center"> 
                      <%=AddUtil.ChangeDate2(a_bean.getMy_nm())%></td>
                    <td align="center"> 
                      <%=AddUtil.ChangeDate2(a_bean.getMy_tel())%></td>
                </tr>				
              	<%	int tot_serv_amt = 0;
					for(int i=0; i<s_r.length; i++){
        				s_bean2 = s_r[i];
						tot_serv_amt += s_bean2.getTot_amt();%>				
                <tr> 
					<%if(s_r.length==1){%>
					<td class=title>�Ƹ���ī</td>
					<%}else{%>
					<%if(s_r.length>1 && i==0){%><td class=title rowspan='<%=s_r.length%>'>�Ƹ���ī</td><%}%>
					<%}%>                    
                    <td class=title>����</td>
                    <td align="center">- </td>
                    <td align="right"> 
                      <%=AddUtil.parseDecimal(s_bean2.getTot_amt())%>��</td>
                    <td align="center"><%=AddUtil.ChangeDate2(s_bean2.getSet_dt())%></td>
                    <td align="center"><%=s_bean2.getOff_nm()%></td>
                    <td align="center"> -</td>
                </tr>
				<%	}%>
                <tr> 
                    <td class=title colspan="2">�հ�</td>
                    <td align="center">- </td>
                    <td align="right"> 
                      <%=AddUtil.parseDecimal(a_bean.getEx_tot_amt()+tot_serv_amt)%>��</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                </tr>
            </table>
        </td>
    </tr>		
    <tr>
		<td class=h></td>
	</tr> 		
	<%if(a_bean.getAccid_st().equals("1") || a_bean.getAccid_st().equals("3")){//����,�ֹ� ������%>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������� || �����ļպ���� û��</span></td>
        <td align="right"> 
        </td>
    </tr>
	<tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title colspan="2">����</td>
                    <td class=title>�ݾ�</td>
                    <td class=title>����</td>
                    <td class=title width=15%>��뺸���</td>
                    <td class=title width=20%>�����</td>
                    <td class=title width=15%>����ó</td>
                </tr>
				<%	int amor_req_tot_amt = 0;
					if(oa_r.length > 0){
						for(int i=0; i<oa_r.length; i++){
    						oa_bean = oa_r[i];
							amor_req_tot_amt += oa_bean.getAmor_req_amt();
				%>	
                <tr> 
                    <td width=10% rowspan="4" class=title>�������(<%=i+1%>)</td>
                    <td width=10% class=title>�׸�</td>
                    <td colspan="2">&nbsp;
                      <%if(oa_bean.getAmor_type().equals("1")){%>������ع��<%}%>
		      <%if(oa_bean.getAmor_type().equals("2")){%>�����ļչ��(����)<%}%>
		    </td>
                    <td rowspan="4" align="center"><%=oa_bean.getOt_ins()%></td>
                    <td rowspan="4" align="center"><%=oa_bean.getMat_nm()%></td>
                    <td rowspan="4" align="center"><%=oa_bean.getMat_tel()%></td>
                </tr>
                <tr>
                  <td class=title>û������</td>
                  <td colspan="2">&nbsp;
                    <%if(oa_bean.getAmor_st().equals("Y")){%>û���Ѵ�<%}%>
                    <%if(oa_bean.getAmor_st().equals("N")){%>û�����Ѵ�<%}%>
		    û���� : <%=c_db.getNameById(oa_bean.getAmor_req_id(),"USER")%>
		  </td>
                </tr>
                <tr>
                  <td class=title>û��</td>
                  <td width=15% align="right">
				    <%=AddUtil.parseDecimal(oa_bean.getAmor_req_amt())%>��</td>
                  <td width=15% align="center">
				    <%=AddUtil.ChangeDate2(oa_bean.getAmor_req_dt())%></td>
                </tr>
                <tr>
                  <td width=10% class=title>�Ա�</td>
                  <td align="right">
				    <%=AddUtil.parseDecimal(oa_bean.getAmor_pay_amt())%>��</td>
                  <td align="center" width=15%>
				    <%=AddUtil.ChangeDate2(oa_bean.getAmor_pay_dt())%></td>
                </tr>
				<%		}
					}%>
				<%if(oa_r.length == 0){%>	
				<tr>
				  <td colspan='7' align="center">����Ÿ�� �����ϴ�.</td>
				</tr>				
				<%}%>
            </table>
        </td>
    </tr>	
	<%	if(amor_req_tot_amt==0 && req_est_amt.equals("")){
			//Vector accid_case = as_db.getAccidS8List2("", "", "", "", "", "", "", "", "", "", "accid_id", c_id+""+accid_id, "", "", "");
			//for (int i = 0 ; i < accid_case.size() ; i++){
				//Hashtable accid_1 = (Hashtable)accid_case.elementAt(i);
				Hashtable accid_1 = as_db.getAccidAmor(c_id, accid_id);
				dlv_mon 	= String.valueOf(accid_1.get("DLV_MON"));
				car_amt 	= String.valueOf(accid_1.get("CAR_AMT"));
				tot_amt 	= String.valueOf(accid_1.get("TOT_AMT"));
				req_est_amt = String.valueOf(accid_1.get("REQ_EST_AMT"));
				amor_est_id = String.valueOf(accid_1.get("AMOR_EST_ID"));
			//}
		}%>		
	<%	if(s_r.length>0 && amor_req_tot_amt==0 && !req_est_amt.equals("0") && !req_est_amt.equals("")){%>
  	<tr>
	    <td colspan=2>�� ����� : <%=dlv_mon%>���̳� / �����ܰ� : <%=AddUtil.parseDecimal(car_amt)%>�� 
		<!--<span class="b"><a href="javascript:estimates_view('<%=amor_est_id%>')" onMouseOver="window.status=''; return true" title="������� ����"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>--> 
		/ ������� : <%=AddUtil.parseDecimal(tot_amt)%>�� / û�����ɱݾ� : <%=AddUtil.parseDecimal(req_est_amt)%>��		
		</td>
	</tr>	
	<%	}%>
    <tr>
		<td class=h></td>
	</tr> 			
	<%}%>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ó�� �����Ȳ</span></td>
        <td align="right"> 
        </td>
    </tr>	
	<tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width=10% class=title>�����������</td>
                    <td width=15%> 
                      &nbsp;<%if(a_bean.getSettle_st().equals("0")){%>����ó��<%}%>
                        <%if(a_bean.getSettle_st().equals("1")){%>����ó��<%}%>
						<input type='hidden' name="settle_st" value="<%=a_bean.getSettle_st()%>">
                    </td>
                    <td class=title width=10%>������������</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="settle_dt" value="<%=AddUtil.ChangeDate2(a_bean.getSettle_dt())%>" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=10%>ó�����</td>
                    <td width=20%> 
                      &nbsp;<select name='settle_id'>
                        <option value="">������</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(a_bean.getSettle_id().equals(user.get("USER_ID"))||a_bean.getReg_id().equals(user.get("USER_ID"))){ out.println("selected"); }%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                     <td class=title width=9%><font color=red>��������</font></td>
                    <td > 
                     &nbsp;<select name='asset_st'>
                        <option value="" <%if(a_bean.getAsset_st().equals("")){%>selected<%}%>>����</option>
                        <option value="Y" <%if(a_bean.getAsset_st().equals("Y")){%>selected<%}%>>����</option>
                      </select>                     
                    </td>
                </tr>
                <tr> 
                    <td class=title>��Ÿ</td>
                    <td colspan="7" height="76"> 
                     &nbsp;<textarea name="settle_cont" cols="105" rows="5"><%=a_bean.getSettle_cont()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
		<td colspan=2>&nbsp;doc_id:<%=doc.getDoc_id()%>, doc_no:<%=doc.getDoc_no()%></td>
	</tr> 			
	<tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=10% rowspan="2">����</td>
                    <td class=title width=20%>������</td>					
                    <td class=title width=20%>�����</td>
                    <td class=title width=20%>����</td>
                    <td class=title width=30%>-</td>
                </tr>
                <tr>
                    <td align="center"><%=user_bean.getBr_nm()%></td>				
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%><%if(doc.getUser_dt1().equals("")){%><br><a href="javascript:doc_sanction('1');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a> <%}%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>
                    <%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){%>
                    <%	if(doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�ӿ�",user_id) || nm_db.getWorkAuthUser("�����������",user_id)){%>
                      <br><a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
                    <%	}else{%>
                    		<%if(user_bean.getBr_id().equals("B1") && nm_db.getWorkAuthUser("�λ�������δ��",user_id)){ %>
                    		  <br><a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
                    		<%} %>
                    <%	} %>
                    <%}%>
                    </font></td>
                    <td align="center"></td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td colspan="2" style='height:18'><font color=#666666>&nbsp;�� ����Ϸ�� �� ���ó�� ����������¸� ����ó���� �����մϴ�.</font> </td>
	</tr>				
	<tr>
	    <td colspan="2" style='height:18'><font color=#666666>&nbsp;�� ������ �� ��å�� �Ա��������� û���� �߰�, ���ó���� ��� �����Ǿ��ٸ� ����ó���ϼŵ� �˴ϴ�. ���ó���� �����ִٸ� ����ó�� ������� ������. </font> </td>
	</tr>				
	<%for(int i=1; i<=10; i++){//�Է°� ����%>
	<tr id=tr_chk<%=i%> style='display:none'>
	    <td colspan="2"><input type='text' name="chk<%=i%>" value='' size="100" class='redtext'></td>
	</tr>	
	<%}%>	
	<%for(int i=1; i<=2; i++){//�Է°� ����%>
	<tr id=tr_sanc<%=i%> style='display:none'>
	    <td colspan="2"><input type='text' name="sanc<%=i%>" value='' size="100" class='chktext'></td>
	</tr>	
	<%}%>		
	<input type='hidden' name="chk_cnt" value="">
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
<script language='javascript'>
<!--
	var fm = document.form1;
	
	cont_chk();
		
	//�Է°� üũ
	function cont_chk(){
		<%if(a_bean.getAccid_st().equals("1") || a_bean.getAccid_st().equals("3")){//����,�ֹ�%>
		<%	if(oa_r.length == 0){//�������� ��ϰǼ�%>
		fm.chk1.value = '* ����,����,�ֹ��� ���� �������ڰ� �־�� �մϴ�.';
		tr_chk1.style.display = '';
		fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;		
		<%	}%>
		<%}%>
		
		<%if(reservs_size > 0){//�������񽺰� �ִ�%>
		<%	if(a_bean.getAccid_st().equals("1") || a_bean.getAccid_st().equals("3")){//����,�ֹ�%>
		//���� Ȯ�� �ȵ� ��� üũ ����  
			if(fm.pre_doc[0].checked == true ){
				<%	if(my_r.length == 0){%>
						fm.chk2.value = '* �������񽺰� �ִµ� ������ û���� ��ϵǾ� ���� �ʽ��ϴ�.';
						tr_chk2.style.display = '';
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;				
				<%	}%>
			}
		  <%}%>
		<%}%>
		
		<%if(!a_bean.getAccid_st().equals("1") && a_bean.getDam_type4().equals("Y")){//����%>		
		<%	if(a_bean.getAsset_st().equals("Y")){%> //������ 
		<%	}else{%> 
			<%	if(s_r.length == 0 ){%> //
				fm.chk3.value = '* ���ر���-���� ���� �ε�, ���� ������� ��ϵǾ� ���� �ʽ��ϴ�.';
				tr_chk3.style.display = 'block';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;		
			<%	}%>
		<%	}%>	
		<%}%>
				
        
		<%if(!String.valueOf(cont.get("CAR_ST")).equals("2") && ins.getCon_f_nm().equals("�Ƹ���ī") && tot_sv_amt > 0 && tot_sv_req_amt == 0){%>
		<%	if(a_bean.getAccid_st().equals("1") || a_bean.getAccid_st().equals("2") || a_bean.getAccid_st().equals("3") || a_bean.getAccid_st().equals("8")){//����,����,�ֹ�,�ܵ�%>
		<%		if(a_bean.getAccid_st().equals("1") && a_bean.getOur_fault_per()==0 ){//100% ���� - ��å�ݾ���.%>
		<%		}else{%>
		fm.chk6.value = '* �������� �ִµ� ��å���� û������ ���� �����Դϴ�.';
		tr_chk6.style.display = '';
		fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;						
		<%		}%>	
		<%	}%>
		<%}%>
		
		// ���ػ���� ��� 1���� ���� �ʼ�  --�� --������  �Է�  - ������ ��� ���� - 202012
		<%if(a_bean.getAccid_st().equals("1") && tot_sv_amt == 0 ){//���ػ�� 1���� �Է� %>
		//������ ��� ������� ��� ���ص� �� 
		<%	if ( a_bean.getAccid_st().equals("1") && a_bean.getOur_fault_per()==0 ){//100% ���� - ����.%> 
		<%		}else{%> 		
				fm.chk7.value = '* ���ػ���ΰ�� ������� 1���̻� ��ϵǾ�� �մϴ�.';
				tr_chk7.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
	    <%   } %>
		<%}%>
		
	
		// ������ ��ĵ - ���񳻿��� ���� ��� 	
		<%if( tot_accid_amt > 0   &&  a_attach_serv_cnt  == 0   ){%>			
		<%		if ( a_bean.getAccid_st().equals("1") && a_bean.getOur_fault_per()==0 ){//100% ���� - ��å�ݾ���.%>		  		
		<%		}else{%>     
		  		<%	if(!s_bean.getRep_cont().equals("��å�� ��û����") ){ %>
					
						fm.chk8.value = '* �������� �ִµ� �������� ��ϵǾ����� ���� �����Դϴ�.';
						tr_chk8.style.display = '';
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;						
				<%	} %>
				
		    <%	}%>		
		<%}%>
				
	
		// ������ û���� ���� ���� Ȯ��   
  		<%if(tot_my_req_amt >0  && my_accid_cnt > 0   ){%>	  
				fm.chk9.value = '* ��� �������� ������ �������� �ٸ��� �ԷµǾ����ϴ�. Ȯ���ϼ���.!! ';
				tr_chk9.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;		   
	   <%}%>
				
		if(toInt(fm.chk_cnt.value)>0){
			fm.sanc1.value = '* '+toInt(fm.chk_cnt.value)+'���� �������� �ʾҽ��ϴ�.';
			tr_sanc1.style.display = '';
		}
		
	}

	//�ٷΰ���
	var s_fm = parent.parent.top_menu.document.form1;
	s_fm.m_id.value = fm.m_id.value;
	s_fm.l_cd.value = fm.l_cd.value;	
	s_fm.c_id.value = fm.c_id.value;
	s_fm.auth_rw.value = fm.auth_rw.value;
	s_fm.user_id.value = fm.user_id.value;
	s_fm.br_id.value = fm.br_id.value;		
	s_fm.client_id.value = fm.client_id.value;		
	s_fm.accid_id.value = fm.accid_id.value;
	s_fm.serv_id.value = "";
	s_fm.seq_no.value = "";
//-->
</script>  
</body>
</html>
