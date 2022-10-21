<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.* " %>
<%@ page import="acar.secondhand.*, acar.estimate_mng.*, acar.res_search.*, acar.car_register.*" %>
<%@ page import="acar.accid.*, acar.car_service.*"%>
<jsp:useBean id="shDb" 		class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<jsp:useBean id="shBn" 		class="acar.secondhand.SecondhandBean" 		scope="page"/>
<jsp:useBean id="rs_db" 	class="acar.res_search.ResSearchDatabase" 	scope="page"/>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>
<jsp:useBean id="oh_db" 	class="acar.off_ls_hpg.OfflshpgDatabase" 	scope="session"/>
<jsp:useBean id="e_bean" 	class="acar.estimate_mng.EstimateBean" 		scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	LoginBean login 	= LoginBean.getInstance();
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String res_yn 		= request.getParameter("res_yn")==null?"":request.getParameter("res_yn");
	String res_mon_yn	= request.getParameter("res_mon_yn")==null?"":request.getParameter("res_mon_yn");
	
	String est_st 		= request.getParameter("est_st")==null?"":request.getParameter("est_st");
	String fee_opt_amt 	= request.getParameter("fee_opt_amt")==null?"":request.getParameter("fee_opt_amt");
	String fee_rent_st 	= request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	
	String est_id 		= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String spe_seq 		= request.getParameter("spe_seq")==null?"":request.getParameter("spe_seq");
	String est_table 	= request.getParameter("est_table")==null?"":request.getParameter("est_table");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String list_from_page 	= request.getParameter("list_from_page")==null?"":request.getParameter("list_from_page");
	
	
	if(user_id.equals("")) user_id = login.getCookieValue(request, "acar_id");
	
	

	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	//�����������
	if(!car_mng_id.equals("")){
		cr_bean = crd.getCarRegBean(car_mng_id);
	}
	
	//���
	Vector vt = oh_db.getServCarHisList(car_mng_id);
	int vt_size = vt.size();
	
	//�������
	ShResBean srBn = shDb.getShRes(car_mng_id);
	
	Vector sr = shDb.getShResList(car_mng_id);
	int sr_size = sr.size();
	
	Vector srh = shDb.getShResHList(car_mng_id);
	int srh_size = srh.size();
	
	//��������
	Hashtable reserv = rs_db.getResCarCase(car_mng_id, "2");
	String use_st = String.valueOf(reserv.get("USE_ST"))==null?"":String.valueOf(reserv.get("USE_ST"));
	
	if(use_st.equals("null")){
		reserv = rs_db.getResCarCase(car_mng_id, "1");
		use_st = String.valueOf(reserv.get("USE_ST"))==null?"":String.valueOf(reserv.get("USE_ST"));
	}
	
	//�ֱ� Ȩ������ ����뿩��
	Hashtable hp = oh_db.getSecondhandCase_20090901("", "", car_mng_id);
	
	
	
	
	//��������
	Hashtable ht = shDb.getShBase(car_mng_id);
	
	String car_comp_id		= String.valueOf(ht.get("CAR_COMP_ID"));
	String car_cd			= String.valueOf(ht.get("CAR_CD"));	
	String car_id			= String.valueOf(ht.get("CAR_ID"));
	String car_seq			= String.valueOf(ht.get("CAR_SEQ"));
	String s_st 			= String.valueOf(ht.get("S_ST"));
	String jg_code 			= String.valueOf(ht.get("JG_CODE"));
	String car_no 			= String.valueOf(ht.get("CAR_NO"));
	String car_name			= String.valueOf(ht.get("CAR_NAME"));
	String init_reg_dt 		= String.valueOf(ht.get("INIT_REG_DT"));
	String secondhand_dt 		= String.valueOf(ht.get("SECONDHAND_DT"));
	String park		 	= String.valueOf(ht.get("PARK"));
	String dlv_dt 			= String.valueOf(ht.get("DLV_DT"));	
	String before_one_year 		= String.valueOf(ht.get("BEFORE_ONE_YEAR"));
	String tot_dist 		= String.valueOf(ht.get("TOT_DIST"));
	String today_dist 		= String.valueOf(ht.get("TODAY_DIST"));
	today_dist 		= String.valueOf(ht.get("TOT_DIST")); //20170629 ��������Ÿ� �������� �����Ѵ�.
	String serv_dt	 		= String.valueOf(ht.get("SERV_DT"));
	String lpg_yn	 		= String.valueOf(ht.get("LPG_YN"));
	String opt		 	= String.valueOf(ht.get("OPT"));
	String colo		 	= String.valueOf(ht.get("COL"));
	int car_amt 			= AddUtil.parseInt((String)ht.get("CAR_AMT"));
	int opt_amt 			= AddUtil.parseInt((String)ht.get("OPT_AMT"));
	int clr_amt 			= AddUtil.parseInt((String)ht.get("COL_AMT"));
	int accid_serv_amt1		= AddUtil.parseInt((String)ht.get("ACCID_SERV_AMT1"));
	int accid_serv_amt2		= AddUtil.parseInt((String)ht.get("ACCID_SERV_AMT2"));	
	String jg_opt_st	 	= String.valueOf(ht.get("JG_OPT_ST"));
	String jg_col_st	 	= String.valueOf(ht.get("JG_COL_ST"));
	String jg_tuix_st	 	= String.valueOf(ht.get("JG_TUIX_ST"));
	String jg_tuix_opt_st	 	= String.valueOf(ht.get("JG_TUIX_OPT_ST"));
		
	//������� ����Ⱓ(����)
	Hashtable carOld 	= c_db.getOld(init_reg_dt);
	//�縮����� ����Ⱓ
	Hashtable carOld2 	= c_db.getOld(secondhand_dt);
	//����Ÿ���� ����Ⱓ
	Hashtable carOld3 	= c_db.getOld(serv_dt);
	
	//�縮�����ݰ�������
	String readonly = "";
	readonly = "readonly";
	
	//���� ���Ҽ� ����� �߰�(2017.10.13)
	int tax_dc_amt	 		= AddUtil.parseInt((String)ht.get("TAX_DC_AMT"));
	
	//�߰����ܰ�����
	EstiJgVarBean ej_bean = e_db.getEstiJgVarCase(jg_code, "");
	//ģȯ���� ���� üũ ���� ����
	String jg_g_7 = String.valueOf(ej_bean.getJg_g_7());
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	if(jg_code.equals("")){
		ej_bean.setJg_a(s_st);
	}
	
	int mon[] = new int[18];
	mon[0]  = 48;
	mon[1]  = 42;
	mon[2]  = 36;
	mon[3]  = 30;
	mon[4]  = 24;
	mon[5]  = 18;
	mon[6]  = 12;
	mon[7]  = 11;
	mon[8]  = 10;
	mon[9]  = 9;
	mon[10] = 8;
	mon[11] = 7;
	mon[12] = 6;
	mon[13] = 5;
	mon[14] = 4;
	mon[15] = 3;
	mon[16] = 2;
	mon[17] = 1;
	
	//������ ����
	CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//�����̷�	
	function view_sh_res_h(){
		var SUBWIN="reserveCarHistory.jsp?car_mng_id=<%=car_mng_id%>";  	
		window.open(SUBWIN, "reserveCarHistory", "left=50, top=50, width=850, height=800, scrollbars=yes, status=yes"); 		
	}

	//��������� �����صα�
	function reserveCar(){
		var fm = document.form1;
		var SUBWIN="reserveCar.jsp?from_page=<%=from_page%>&car_mng_id=<%=car_mng_id%>&user_id=<%=user_id%>&situation=<%=srBn.getSituation()%>&damdang_id=<%=srBn.getDamdang_id()%>&reg_dt=<%=srBn.getReg_dt()%>&ret_dt="+fm.ret_dt.value;
		window.open(SUBWIN, "reserveCar", "left=250, top=250, width=420, height=300, scrollbars=no, status=no"); 		
	}


	
	//����޸�����ϱ�
	function reserveCarM(seq, situation, memo){
		var fm = document.form1;
		var SUBWIN="reserveCarM.jsp?user_id=<%=user_id%>&car_mng_id=<%=car_mng_id%>&seq="+seq+"&situation="+situation+"&memo="+memo;
		window.open(SUBWIN, "reserveCar", "left=250, top=250, width=420, height=300, scrollbars=no, status=no"); 		
	}

	//��������ϱ�
	function cancelCar(car_mng_id, seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;		
		if(!confirm("������ ��� �Ͻðڽ��ϱ�?"))	return;		
		fm.action = "cancelCar.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	//���࿬���ϱ�
	function reReserveCar(car_mng_id, seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;		
		if(!confirm("������ ���� �Ͻðڽ��ϱ�?"))	return;		
		fm.action = "reReserveCar.jsp";
		fm.target = "i_no";
		fm.submit();	
	}
	//���Ȯ������ ��ȯ�ϱ�
	function reserveCar2Cng(car_mng_id, seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;		
		if(!confirm("����߿��� ���Ȯ������ ��ȯ �Ͻðڽ��ϱ�?"))	return;		
		fm.action = "reserveCar2cng.jsp";
		fm.target = "i_no";
		fm.submit();			
	}
	
	//����
	function EstiMate (st, value, nm, a_a, rent_way, a_b, target){
		var fm = document.form1;
		
		<%if(jg_code.equals("")){%>
		alert('�����ڵ尡 �����ϴ�.\n\n������ �ȵ˴ϴ�.');
		return;
		<%}%>
		
		if(fm.apply_secondhand_price.value == '' || fm.apply_secondhand_price.value == '0'){
			alert('�縮������������ ������ �ʾҽ��ϴ�.\n\n������ �����̰��忡�� �����Ͻʽÿ�.');
			return;
		}
		
		if(value == '�����Ұ�' || value == '��Ʈ�Ұ�'){ alert(value); return; }
		
		//������ ���������
		<%if(AddUtil.parseInt(car_comp_id) >  5){%>
			if(st == '1'){
				if(!confirm("���������� ����� ���� �������� �����Ϸ��� ��� ��������� ���������� �þƾ� �մϴ�.\n\n���������� �����̽��ϱ�?"))	return;
			}
		<%}%>
		
		fm.esti_nm.value 	= nm;
		fm.a_a.value 		= a_a+""+rent_way;
		fm.a_b.value 		= a_b;
		fm.st.value 		= st;		
		
		fm.pp_st.value 	= '2';
		fm.rg_8.value 	= '25'; //20->30(20081216)->25(20090117)
		
		if(st == 'all'){
			fm.pp_st.value 	= '2';
			fm.rg_8.value 	= '25'; //20->30(20081216)->25(20090117)
		}else{
			//����Ÿ� �Է±Ⱓ üũ
			if('<%=serv_dt%>' != ''){
				var serv_mon = <%= carOld3.get("YEAR") %>*12+<%= carOld3.get("MONTH") %>;
				if(serv_mon >6){
					if(!confirm("����Ÿ� ���� �Է��Ϸκ��� "+serv_mon+"������ ����Ͽ����ϴ�.\n\n���� ��������Ÿ��� ������ �Ұ�� ����Ȯ�� ����� ����˴ϴ�.\n\n�����Ͻðڽ��ϱ�?"))	return;
				}
				if(st == '2' || st == '3' || st == '4'){
					var serv_days = (<%= carOld3.get("YEAR") %>*365)+(<%= carOld3.get("MONTH") %>*30)+<%= carOld3.get("DAY") %>;
					if(serv_days >7){
						if(!confirm("����Ÿ�Ȯ�����ڷκ��� 7���̻�("+serv_days+"��) ����Ͽ����ϴ�. \n\n���� ����Ÿ��� ������ �Ұ�� ����Ȯ�� ����� ����˴ϴ�. \n\n�����Ͻðڽ��ϱ�?"))	return;
					}
				}
			}
		}
		
		fm.target = target;
		fm.action = '/acar/secondhand/esti_mng_i_20090901.jsp';
		fm.submit();		
	}

	//�������������ϱ�	
	function RegRentCont(){
		var fm = document.form1;
		fm.target = 'd_content';
		fm.action = '/agent/res_search/car_res_list.jsp';
		fm.submit();
	}	
	
	//���� ������ã��
	function search_cust(){
		var fm = document.form1;
		var SUBWIN="/agent/estimate_mng/search_cust_list.jsp?from_page=/agent/secondhand/secondhand_price_20090901.jsp&t_wd="+fm.cust_nm.value;		
		window.open(SUBWIN, "SubCust", "left=10, top=10, width=1250, height=800, scrollbars=yes, status=yes");		
	}		
	
	//�������������뺸�� ���Կ���
	function SetComEmpYn(){
		var fm = document.form1;
		<%if((AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000) || (AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000)){%>
		if(fm.doc_type.value == '1'){
			fm.com_emp_yn.value = 'Y';
		}else{
			fm.com_emp_yn.value = 'N';
		}
		<%}%>
	}	
	
	//�⺻��纸���ֱ�
	function opt(){  
		var fm = document.form1;
		var SUBWIN="/acar/main_car_hp/opt.jsp?car_id=<%=car_id%>&car_seq=<%=car_seq%>&from_page=<%=from_page%>";	
		window.open(SUBWIN, "OPT", "left=10, top=10, width=798, height=550, scrollbars=yes, status=yes, resizable=no");
	}

	//�ҷ��� 
	function view_badcust()
	{
		var fm = document.form1;
	    if (fm.cust_nm.value == '') {
	    	alert('��ȣ �Ǵ� ������ �Է��Ͻʽÿ�');
	    	fm.cust.focus();
	    	return;
	    }	
		window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_mng_atype_i.jsp&est_nm='+fm.cust_nm.value+'&est_tel='+fm.cust_tel.value+'&est_mail='+fm.cust_email.value+'&est_fax='+fm.cust_fax.value, "BADCUST", "left=10, top=10, width=1400, height=900, resizable=yes, scrollbars=yes, status=yes");
		return;
	}	    	
	
//-->
</script>
</head>

<body>
<form name="form1" action="" method="POST" >
<input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
<input type="hidden" name="br_id" 		value="<%=br_id%>">
<input type="hidden" name="user_id" 		value="<%=user_id%>">
<input type="hidden" name="car_mng_id" 		value="<%=car_mng_id%>">
<input type="hidden" name="rent_mng_id" 	value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">
<input type="hidden" name="a_e" 		value="<%=s_st%>">
<input type="hidden" name="car_no" 		value="<%=car_no%>">
<input type="hidden" name="init_reg_dt" 	value="<%=init_reg_dt%>">
<input type="hidden" name="before_one_year" 	value="<%=before_one_year%>">
<input type="hidden" name="real_km" 		value="<%=today_dist%>">
<input type="hidden" name="today_dist" 		value="<%=today_dist%>">
<input type="hidden" name="lpg_yn"	 	value="<%=lpg_yn%>">
<input type='hidden' name="est_st"		value="<%=est_st%>">      
<input type='hidden' name="fee_opt_amt"		value="<%=fee_opt_amt%>">        
<input type='hidden' name="fee_rent_st"		value="<%=fee_rent_st%>">        
<input type='hidden' name="jg_code"		value="<%=jg_code%>">        
<input type="hidden" name="reg_code"		value="<%=hp.get("REG_CODE")%>">
<input type="hidden" name="upload_dt"		value="<%=hp.get("UPLOAD_DT")%>">
<input type="hidden" name="mode" 		value="">
<input type="hidden" name="st"	 		value="">
<input type="hidden" name="car_old_exp" 	value="">
<input type="hidden" name="apply_sh_pr" 	value="">
<input type="hidden" name="seq" 		value="">
<input type="hidden" name="compute" 		value="N">
<input type="hidden" name="detail" 		value="N">
<!--��������-->
<input type="hidden" name="esti_nm"		value="">
<input type="hidden" name="a_a"			value="">
<input type="hidden" name="a_b"			value="">
<input type="hidden" name="pp_st"		value="">
<input type="hidden" name="rg_8"		value="">
<!--��������-->
<input type="hidden" name="rent_st"		value="1"><!--�������縮��-->
<input type="hidden" name="spr_yn" 		value="1">
<input type="hidden" name="lpg_yn" 		value="0">
<input type="hidden" name="lpg_kit" 		value="">
<input type="hidden" name="a_h" 		value="1">
<input type="hidden" name="ins_dj" 		value="2">
<input type="hidden" name="ins_age" 		value="1">
<input type="hidden" name="ins_good" 		value="0">
<input type="hidden" name="gi_yn" 		value="0">
<input type="hidden" name="car_ja" 		value="300000">
<input type="hidden" name="from_page" 		value="secondhand">
<input type="hidden" name="rent_dt" 		value="<%=AddUtil.getDate()%>">

<input type="hidden" name="situation" 		value="<%//=srBn.getSituation()%>">
<input type="hidden" name="damdang_id" 		value="<%//=srBn.getDamdang_id()%>">
<input type="hidden" name="shres_reg_dt" 	value="<%//=srBn.getReg_dt()%>">
<input type="hidden" name="shres_seq" 		value="">

<input type="hidden" name="est_id" 		value="<%=est_id%>">
<input type='hidden' name="spe_seq"		value="<%=spe_seq%>">      
<input type='hidden' name="est_table"		value="<%=est_table%>">        
<input type='hidden' name="from_page"		value="<%=from_page%>">   
<input type='hidden' name="list_from_page" 	value="<%=list_from_page%>">  
<input type='hidden' name="jg_w" 		value="<%=ej_bean.getJg_w()%>">  
<!--����Ʈ-->
<input type="hidden" name="tot_rm"		value="">  
<input type="hidden" name="tot_rm1"		value="">  
<input type="hidden" name="per_rm"		value="">  
           



<table border=0 cellspacing=0 cellpadding=0 width=100%>

    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span>
		<%if(srh_size>0){%>
		&nbsp;&nbsp;<a href="javascript:view_sh_res_h()" title="�̷�"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a>&nbsp;(<%=srh_size%>��)
		<%}%>
		</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width="5%">����</td>				
                    <td class="title" width="10%">�����</td>
                    <td class="title" width="10%">�����Ȳ</td>					
                    <td class="title" width="15%">����Ⱓ</td>					
                    <td class="title" width="35%">�޸�</td>
                    <td class="title" width="10%">�������</td>										
                    <td class="title" width="15%">ó��</td>					
                </tr>
				<%	int sh_res_reg_chk = 0;
					for(int i = 0 ; i < sr_size ; i++){
						Hashtable sr_ht = (Hashtable)sr.elementAt(i);
						if(String.valueOf(sr_ht.get("SITUATION")).equals("2")) sh_res_reg_chk = 1;
						%>
                <tr> 
                    <td align="center"><%=i+1%></td>				
                    <td align="center"><%=c_db.getNameById(String.valueOf(sr_ht.get("DAMDANG_ID")),"USER")%></td>
                    <td align="center"><%	if(String.valueOf(sr_ht.get("SITUATION")).equals("0"))			out.print("�����");
        									else if(String.valueOf(sr_ht.get("SITUATION")).equals("2"))		out.print("���Ȯ��");
                    						else if(String.valueOf(sr_ht.get("SITUATION")).equals("3"))		out.print("���Ȯ��");%></td>
                    <td align="center">
					<%if(!String.valueOf(sr_ht.get("RES_ST_DT")).equals("")){%>					
					<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_ST_DT"))) %>~<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_END_DT"))) %>
					<%}%>
					</td>
                    <td>&nbsp;
                    <%if(user_id.equals(String.valueOf(sr_ht.get("DAMDANG_ID")))){%>
                    <a href="javascript:reserveCarM('<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("MEMO")%>');" title='�޸�����ϱ�'><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>&nbsp;
                    <%	}%>
                    <%=sr_ht.get("MEMO")%>
                    </td>
                    <td align="center"><%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("REG_DT"))) %></td>					
                    <td align="center">
					<%if(user_id.equals(String.valueOf(sr_ht.get("DAMDANG_ID")))){%>
					<%	if(i==0 && sh_res_reg_chk==0 && String.valueOf(sr_ht.get("SITUATION")).equals("0")){%>
					<a href="javascript:reserveCar2Cng('<%=car_mng_id%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=sr_ht.get("REG_DT")%>');" title='�������� ���Ȯ���ϱ�'>Ȯ��</a>&nbsp;&nbsp; 
					<%	}%>
					<%	if(String.valueOf(sr_ht.get("SITUATION")).equals("2")){%>
					<a href="javascript:reReserveCar('<%=car_mng_id%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=sr_ht.get("REG_DT")%>');" title='�������� �����ϱ�'>����</a>&nbsp;&nbsp; 
					<%	}%>
					<a href="javascript:cancelCar('<%=car_mng_id%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=sr_ht.get("REG_DT")%>');" title='�������� ����ϱ�'>���</a>&nbsp;&nbsp; 
					<%}%>
					</td>					
                </tr>
				<%}%>
				<%if(sr_size==0){%>
                <tr> 	
                    <td align="center" colspan="7">��ϵ� ����Ÿ�� �����ϴ�.</td>											
                </tr>				
				<%}%>
            </table>
	    </td>
    </tr>
	<%if(sh_res_reg_chk == 0 && sr_size < 3){%>
    <tr>
        <td align="right"><a href="javascript:reserveCar();" title='���������ϱ�'><img src=/acar/images/center/button_cryy.gif align=absmiddle border=0></a></td>
    </tr>		
	<%}%>
    <tr>
        <td>* ���Ȯ���� ��쿡 ����Ⱓ�� �����Ҽ� �ֽ��ϴ�. ���� ���������� ������ �����Ͽ� 4���� ����˴ϴ�. ���Ȯ�� ����Ⱓ�� �������ڸ� �����մϴ�.</td>
    </tr>			
    <tr>
        <td>* 1���� ������ �ڵ���� Ȥ�� �������ó���� ��� ������������ ��������˴ϴ�. ���Ȯ���� ���� ��쿡�� �ű� ������ ����Ҽ� �����ϴ�. </td>
    </tr>			
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������Ȳ</span></td>
    </tr>
	<%if(!use_st.equals("null")){%>
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width="16%">��౸��</td>
                    <td width="34%">&nbsp;<%=reserv.get("RENT_ST")%></td>
                    <td class="title" width="16%">�����</td>
                    <td width="34%">&nbsp;<%=reserv.get("FIRM_NM")%>&nbsp;<%=reserv.get("CUST_NM")%></td>
    		    </tr>
    		    <tr>
                    <td class="title">�뿩�Ⱓ</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("DELI_DT")))%>~<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RET_DT")))%>
					&nbsp;&nbsp;&nbsp;
					[���] <%=AddUtil.ChangeDate2(String.valueOf(reserv.get("REG_DT")))%> <%=c_db.getNameById(String.valueOf(reserv.get("REG_ID")),"USER")%>
					</td>
                </tr>
            </table>
	    </td>
    </tr>
    	<%	if(String.valueOf(reserv.get("RENT_ST")).equals("�����뿩")){%>
	<input type="hidden" name="ret_dt" 		value="">
	<%	}else{%>
	<input type="hidden" name="ret_dt" 		value="<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RET_DT2")))%>">
	<%	}%>
	<%}else{%>
	<input type="hidden" name="ret_dt" 		value="">
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width="16%">��౸��</td>
                    <td width="34%">&nbsp;���</td>
                    <td class="title" width="16%">����ġ</td>
                    <td width="34%">&nbsp;
        			  <%for(int i = 0 ; i < good_size ; i++){
							CodeBean good = goods[i];
							if(park.equals(good.getNm_cd()))%><%= good.getNm()%>
						<%}%>
        			</td>
                </tr>
            </table>
	    </td>
    </tr>
	<%}%>
	<tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�縮�������Ȳ</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width="16%">�縮���������</td>
                    <td width="34%">&nbsp;<%=AddUtil.ChangeDate2(secondhand_dt)%></td>
                    <td class="title" width="16%">����Ⱓ</td>
                    <td width="34%">&nbsp;<%= carOld2.get("MONTH") %>����<%= carOld2.get("DAY") %>��
        			</td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
	    <td class=h></td>
	</tr>
	<%if(!cr_bean.getOff_ls().equals("0")){%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ű�����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width="16%">������������</td>
                    <td >&nbsp;
                        <%if(cr_bean.getOff_ls().equals("1")){%>[�Ű�����]<%}%>
                        <%if(cr_bean.getOff_ls().equals("2")){%>[�Ҹ�]<%}%>
                        <%if(cr_bean.getOff_ls().equals("3")){%>[�������ǰ]<%}%>
                        <%if(cr_bean.getOff_ls().equals("4")){%>[���ǰ��]<%}%>					
                        <%if(cr_bean.getOff_ls().equals("5")){%>[����峫��]<%}%>					
                        <%if(cr_bean.getOff_ls().equals("6")){%>[�Ű��Ϸ�]<%}%>		
						<%if(cr_bean.getOff_ls().equals("3")){
								//�������
								Hashtable ht_apprsl 	= shDb.getCarApprsl(car_mng_id);%>
						: 
						<%if(!String.valueOf(ht_apprsl.get("ACTN_DT")).equals("")){%>
						������� - <%=AddUtil.ChangeDate2(String.valueOf(ht_apprsl.get("ACTN_DT")))%>,
						<%}else{%>
						������ - <%=AddUtil.ChangeDate2(String.valueOf(ht_apprsl.get("APPRSL_DT")))%>, 
						<%}%>
						��ǰ����� - <%=ht_apprsl.get("FIRM_NM")%>
						<%}%>															
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width="16%">���ʵ����</td>
                    <td width="34%">&nbsp;<%=AddUtil.ChangeDate2(init_reg_dt)%></td>
                    <td class="title" width="16%">�������</td>
                    <td width="34%">&nbsp;<%=AddUtil.ChangeDate2(dlv_dt)%> 
					 (����:
					    <%=c_db.getNameByIdCode("0039", "", cr_bean.getFuel_kd())%>					    
					 )</td>
                </tr>
                <tr> 
                    <td class="title" width="16%">����</td>
                    <td width="34%">&nbsp;<%= carOld.get("YEAR") %>��<%= carOld.get("MONTH") %>����<%= carOld.get("DAY") %>��(��������:<%=AddUtil.getDate()%>)
					<%if(cr_bean.getCar_use().equals("1")){
							int car_end_d_day = c_db.getCar_D_day("car_end_dt", car_mng_id);
					%>
					<br>&nbsp;<b>���ɸ����� : <%=cr_bean.getCar_end_dt()%> <%if(car_end_d_day <= 30){ %><font color=red>(D-day <%=car_end_d_day%>��)</font><%} %></b>
					<%}%>
					</td>
                    <td class="title" width="16%">����Ÿ�</td>
                    <td width="34%">&nbsp;�����Է�:<%=AddUtil.parseDecimal(tot_dist)%>km, <%=AddUtil.ChangeDate2(serv_dt)%></td>
                </tr>		
    		    <tr>
        		    <td class='title'> �˻���ȿ�Ⱓ </td>
        		    <%	
        		    	int car_maint_d_day = c_db.getCar_D_day("car_maint_dt", car_mng_id);
					%>
        		    <td>&nbsp;<b><%=cr_bean.getMaint_st_dt()%>~<%=cr_bean.getMaint_end_dt()%> <%if(car_maint_d_day <= 30){ %><font color=red>(D-day <%=car_maint_d_day%>��)</font><%} %></b></td>
                	<td class='title'>������ȿ�Ⱓ</td>
        		    <td>&nbsp;<b><%=cr_bean.getTest_st_dt()%>~<%=cr_bean.getTest_end_dt()%></b></td>
    		    </tr>
    		    <tr>
        		    <td class='title'> �������� </td>
        		    <td>&nbsp;1�� <%= AddUtil.parseDecimal(accid_serv_amt1) %>��, 2�� <%= AddUtil.parseDecimal(accid_serv_amt2) %>�� </td>
                	<td class='title'>����׻�� �ܰ��ݿ�</td>
        		    <td>&nbsp;���� : <%=jg_col_st%>, �ܰ� : <%=jg_opt_st%>
        		    	<!--&nbsp;&nbsp;&nbsp;&nbsp;TUIX/TUON Ʈ������ : <%=jg_tuix_st%>, �ɼǿ��� : <%=jg_tuix_opt_st%>-->
        		    	</td>
    		    </tr>		    		    		                  
            </table>
	    </td>
    </tr>
    <%if(!cr_bean.getDist_cng().equals("")){%>
    <tr>
      <td>* <font color=green><%=cr_bean.getDist_cng()%></font></td>
    </tr>
    <%}else{%>
    <tr></tr><tr></tr>
    <%}%>
    <tr> 
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width="16%">������</td>
                    <td width="68%">&nbsp;<%= c_db.getNameById(car_comp_id, "CAR_COM") %></td>
                    <td class="title" width="16%">�ݾ�</td>
                </tr>
                <tr> 
                    <td class="title">����</td>
                    <td>&nbsp;<a href="javascript:opt();" onMouseOver="window.status=''; return true"><%=car_name%></a>&nbsp;(<%=jg_code%>)</td>
                    <td align="center"><input type="text" name="car_amt" value="<%= AddUtil.parseDecimal(car_amt) %>" size="15" class="whitenum">��</td>
                </tr>
                <tr> 
                    <td class="title">�ɼ�</td>
                    <td>&nbsp;<a href="javascript:opt();" onMouseOver="window.status=''; return true"><%=opt%></a></td>
                    <td align="center"><input type="text" name="car_amt" value="<%= AddUtil.parseDecimal(opt_amt) %>" size="15" class="whitenum">��</td>
                </tr>
                <tr> 
                    <td class="title">����</td>
                    <td>&nbsp;<%=colo%></td>
                    <td align="center"><input type="text" name="car_amt" value="<%= AddUtil.parseDecimal(clr_amt) %>" size="15" class="whitenum">��</td>
                </tr>
                <!-- ���� ���Ҽ� ���� �߰�(2017.10.13) -->
<%
	if(jg_g_7.equals("1") || jg_g_7.equals("2") || jg_g_7.equals("3") || jg_g_7.equals("4")){
%>                
                <tr>
                    <td class="title">���� ���Ҽ� ����</td>
                    <td>&nbsp;</td>
                    <td align="center"><input type="text" name="car_amt" value="- <%= AddUtil.parseDecimal(tax_dc_amt) %>" size="15" class="whitenum">��</td>
                </tr>
<%
	}
%> 
                <tr> 
                    <td class="title">������</td>
                    <td align="right"></td>
                    <td align="center">- <input type="text" name="depreciation" value="<%= AddUtil.parseDecimal(clr_amt) %>" size="15" class="defaultnum">��</td>
                </tr>
                <tr> 
                    <td class="title" colspan="2">�縮�����ذ���</td>
                    <td align="center"><input type="text" name="apply_secondhand_price" value="<%=AddUtil.parseDecimal(String.valueOf(hp.get("APPLY_SH_PR")))%>" size="15" class="defaultnum">��</td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>
    <tr></tr><tr></tr>
    <tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span>
            &nbsp;&nbsp;<a href="javascript:search_cust()" onMouseOver="window.status=''; return true" title="����ȸ�ϱ�. Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a>
            
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <font color=red>�� �ҷ��� Ȯ���ϱ�</font>
        	&nbsp;&nbsp;&nbsp;        	
        	<input type="button" class="button" id="bad_cust" value='��Ȯ��' onclick="javascript:view_badcust();">
        	<input name="badcust_chk" type="text" class="text"  readonly value="" size="1">                        
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width="16%">��ȣ/����</td>
                    <td width="34%">&nbsp;<input type="text" name="cust_nm" value="<%=e_bean.getEst_nm()%>" size="40" class=default style='IME-MODE: active'></td>
                    <td class="title" width="16%">�����</td>
                    <td width="34%">
        			  &nbsp;<select name='damdang_id2' class=default>            
                        <option value="">������</option>
        		        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); 
        					%>
          			    <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
        			  </select>
        			</td>
                </tr>
                <tr> 
                    <td class="title" width="16%">��ȭ��ȣ</td>
                    <td width="34%">&nbsp;<input type="text" name="cust_tel" value="<%=e_bean.getEst_tel()%>" size="15" class=default ></td>
                    <td class="title" width="16%">�ѽ���ȣ</td>
                    <td width="34%">&nbsp;<input type="text" name="cust_fax" value="<%=e_bean.getEst_fax()%>" size="15" class=default></td>
                </tr>		  
                <tr> 
                    <td class="title">�̸����ּ�</td>
                    <td>&nbsp;<input type="text" name="cust_email" value="<%=e_bean.getEst_email()%>" size="40" class=default  style='IME-MODE: inactive'></td>
                    <td class="title">������</td>
                    <td>&nbsp;<select name="doc_type" class=default <%if((AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000) || (AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000)){%>onChange="javascript:SetComEmpYn()"<%}%>>
                            <option value=""  <%if(e_bean.getDoc_type().equals("")){%>selected<%}%>>����</option>
                            <option value="1" <%if(e_bean.getDoc_type().equals("1")){%>selected<%}%>>���ΰ�</option>
                            <option value="2" <%if(e_bean.getDoc_type().equals("2")){%>selected<%}%>>���λ����</option>
                            <option value="3" <%if(e_bean.getDoc_type().equals("3")){%>selected<%}%>>����</option>
                          </select>
                          &nbsp;(�����п� ���� �������� �ʿ伭���� ǥ���մϴ�.) 
                          </td>
                </tr>
                <%if((AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000) || (AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000)){%>
                <tr>
                    <td class="title">�������������뺸��</td>
                    <td colspan='3'>&nbsp;<select name="com_emp_yn" class=default>
                            <option value="N">�̰���</option>
                            <option value="Y">����</option>
                          </select>
                          
                    </td>
                </tr>
                <%}else{%>
                <input type="hidden" name="com_emp_yn"		value="N">
                <%}%>
            </table>
	    </td>
    </tr>
    <tr>
        <td>&nbsp;<font color="#999999">�� �������� �Է��ϰ� �⺻�̳� ���������� Ŭ���ϸ�, �������� �ݿ��˴ϴ�.</font></td>
    </tr>	
    <tr> 
        <td align="right">
    		<a href="javascript:EstiMate('1', '', '', '<%if(cr_bean.getCar_use().equals("1")){%>2<%}else{%>1<%}%>', '1', '1', '_blank');" title='����������� �����ϱ�'><img src=/acar/images/center/button_est_cgdc.gif align=absmiddle border=0></a>
    		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        	<a href="javascript:RegRentCont();" title='����������� ����ϱ�'><img src=/acar/images/center/button_reg_cgdc.gif align=absmiddle border=0></a>
	</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>


<script language="JavaScript" type="text/JavaScript">
	<%if(jg_code.equals("")){%>
		alert('�����ڵ尡 �����ϴ�.\n\n��������� �ȵ˴ϴ�.\n\nȮ���Ͻʽÿ�.');
	<%}%>
	
	var fm = document.form1;
	fm.car_old_exp.value = (<%= carOld.get("YEAR") %>*12)+<%= carOld.get("MONTH") %>;
	
	
	fm.depreciation.value 	= parseDecimal(<%=car_amt+opt_amt+clr_amt-tax_dc_amt%> - toInt(parseDigit(fm.apply_secondhand_price.value)));
	
</script>
</body>
</html>