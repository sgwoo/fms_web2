<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.fee.*, acar.bill_mng.*, acar.client.*, acar.car_register.*, acar.car_mst.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="atp_db" scope="page" class="acar.kakao.AlimTemplateDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_cnt 		= request.getParameter("s_cnt")==null?"":request.getParameter("s_cnt");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st 		= request.getParameter("r_st")==null?"1":request.getParameter("r_st");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String msg_gubun = request.getParameter("msg_gubun")==null?"":request.getParameter("msg_gubun");
	
	//���⺻����
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));		
		
	//[���]�������� ��ȸ
	Hashtable insur = a_db.getInsurOfCont(l_cd, m_id);
	
	//cont_view
	Hashtable cont = a_db.getContViewCase(m_id, l_cd);
	String car_num = String.valueOf(cont.get("CAR_NO"));
	String car_name = String.valueOf(cont.get("CAR_NM"));
	
	//�����⺻����
   	ContCarBean f_fee_etc = a_db.getContFeeEtc(m_id, l_cd, "1");
   
 	//������
	ClientBean client = al_db.getNewClient(insur.get("CLIENT_ID")+"");
   
  	//���ΰ�����������
	Vector car_mgrs = a_db.getCarMgrListNew(m_id, l_cd, "");
	int mgr_size = car_mgrs.size();
	String f_person = "";
    String s_person = "";
    for(int i = 0 ; i < mgr_size ; i++){
		CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
       	if(mgr.getMgr_st().equals("�߰��̿���") || mgr.getMgr_st().equals("�߰�������")){
        	s_person =mgr.getMgr_nm();
       	}
   	} 
   
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
   
  	UsersBean user_bean = umd.getUsersBean(String.valueOf(insur.get("MNG_ID"))); 
  	UsersBean sener_user_bean = umd.getUsersBean(ck_acar_id);
  
  	String url1 = "http://fms1.amazoncar.co.kr/mailing/total/car_mng_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+r_st+"";
  	String url2 = "http://fms1.amazoncar.co.kr/acar/ars/ars_info_accident.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd;
	
	String insur_mng_name = String.valueOf(insur.get("USER_NM"));						// ���ó�� �����  
	String insur_mng_pos =String.valueOf(insur.get("USER_POS"));		// ���ó�� ����� ���� 
	String insur_mng_phone =String.valueOf(insur.get("USER_M_TEL"));		// ���ó�� ����� ��ȭ 
	String insurance_name = String.valueOf(insur.get("INS_COM_NM"));		// ���ó�� �����
	String insurance_phone = String.valueOf(insur.get("INS_TEL"));			// ���ó�� ����� ��ȭ		
	String sos_service_info = "����Ÿ�ڵ��� (1588-6688)";								// ����⵿	
	String marster_car_num = "1588-6688"; //������ �ڵ��� ����ó
	String sk_net_num = "1670-5494"; //sk��Ʈ���� ����ó
	String sk_net_info = "sk��Ʈ���� (1670-5494)"; //sk��Ʈ���� ����ó
	String car_service_info = "���ǵ����Ʈ (https://www.speedmate.com/shop_search/shop_search.do)";		// �����ü
	//String insur_info_url = ShortenUrlGoogle.getShortenUrl(url1);
	//String accident_url = ShortenUrlGoogle.getShortenUrl(url2);
	String insur_info_url = url1;
	String accident_url = url2;
	
	insur_mng_pos =user_bean.getUser_pos();		// ���ó�� ����� ���� 
	
	String dist = AddUtil.parseDecimal(f_fee_etc.getAgree_dist());			// ����Ÿ�
	String dist_fee = AddUtil.parseDecimal(f_fee_etc.getOver_run_amt());	// ����Ÿ� �ʰ� ���
	String driver = String.valueOf(client.getClient_nm()) + " ";			// ������
	String driver2 = s_person + " ���� ";			// ������
	
	if(!s_person.equals("")){
		//driver += ", " + s_person + " ��";
	}else{
		driver2 = "����";	
	}
	
	String visit_place = null;												// �ݳ����
	String return_place = null;												// �൵
	String parking_map = "";													// �൵
	if ((insur.get("BR_ID")+"").equals("D1")) {
		visit_place = "����ī��ũ 2�� (042-824-1770)\n������ ����� ���ɱ� 100";
		//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dj_hd.jpg";
		parking_map = "http://kko.to/5kTS9j74J";
	}
	else if ((insur.get("BR_ID")+"").equals("G1")) {
		visit_place = "�������������� (053-582-2998)\n�뱸�� �޼��� �޼����109�� 58";
		//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dg_hd.jpg";
		parking_map = "http://kko.to/9ZRdpTTmd";
	}
	else if ((insur.get("BR_ID")+"").equals("J1")) {
		visit_place = "��1���ڵ��������� (062-385-0133)���� ���� �󹫴����� 131-1";
		//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_k_sm.jpg";
		parking_map = "http://kko.to/-VXvHD_ol";
	}
	else if ((insur.get("BR_ID")+"").equals("B1")) {
		visit_place = "�ΰ��ڵ������� (051-851-0606)\n�λ� ������ ����õ�� 270���� 5";
		//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_p_bugyung.jpg";
		parking_map = "http://kko.to/0peONPKDI";
	}
	else {
		visit_place = "���������� (02-6263-6378)\n����� �������� �������� 34�� 9";
		//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_s_youngnam.jpg";
		parking_map = "http://kko.to/M3C3ewyaQ";
	}
	if(!parking_map.equals("")){
		//return_place = "�൵ �ٷ� ���� "+ShortenUrlGoogle.getShortenUrl(parking_map); // �൵
		return_place = "�൵ �ٷ� ���� "+parking_map; // �൵
	}	
	
	String msg = "";
	
	if(msg_gubun.equals("mrent")){
		/*
		List<String> fieldList = Arrays.asList(client.getFirm_nm(), driver, dist, dist_fee, insur_mng_name, insur_mng_phone,
						insurance_name, insurance_phone,  car_service_info, sos_service_info,  insur_mng_name,  insur_mng_phone, visit_place, return_place);	
		AlimTemplateBean templateBean = atp_db.selectTemplate("acar0110");
    	String content = templateBean.getContent();
	  	for (String field : fieldList) {
    		content = content.replaceFirst("\\#\\{.*?\\}", field);
	    }
	    msg = content;
	    */
		List<String> fieldList = Arrays.asList(client.getFirm_nm(), driver, driver2, dist, dist_fee, insur_mng_name, insur_mng_phone,
				insurance_name, insurance_phone);	
		AlimTemplateBean templateBean = atp_db.selectTemplate("acar_0262");
		String content = templateBean.getContent();
		for (String field : fieldList) {
			content = content.replaceFirst("\\#\\{.*?\\}", field);
		}
		msg = content;	 
		List<String> fieldList2 = Arrays.asList(client.getFirm_nm(), car_service_info, sos_service_info, sk_net_info, insur_mng_name,  insur_mng_phone, visit_place, return_place, client.getFirm_nm());	
		AlimTemplateBean templateBean2 = atp_db.selectTemplate("acar_0264");
		String content2 = templateBean2.getContent();
		for (String field : fieldList2) {
			content2 = content2.replaceFirst("\\#\\{.*?\\}", field);
		}
		msg = msg + "\n\n\n"+ content2;
	}else if(msg_gubun.equals("mrent1")){
		List<String> fieldList = Arrays.asList(client.getFirm_nm(), driver, driver2, dist, dist_fee, insur_mng_name, insur_mng_phone,
				insurance_name, insurance_phone);	
		AlimTemplateBean templateBean = atp_db.selectTemplate("acar_0262");
		String content = templateBean.getContent();
		for (String field : fieldList) {
			content = content.replaceFirst("\\#\\{.*?\\}", field);
		}
		msg = content;
	}else if(msg_gubun.equals("mrent2")){
		List<String> fieldList = Arrays.asList(client.getFirm_nm(), car_service_info, sos_service_info, sk_net_info, insur_mng_name,  insur_mng_phone, visit_place, return_place, client.getFirm_nm());	
		AlimTemplateBean templateBean = atp_db.selectTemplate("acar_0264");
		String content = templateBean.getContent();
		for (String field : fieldList) {
			content = content.replaceFirst("\\#\\{.*?\\}", field);
		}
		msg = content;
	}else if (msg_gubun.equals("accid")){
		List<String> fieldList = Arrays.asList(client.getFirm_nm(), cr_bean.getCar_no(), insurance_name, insurance_phone, marster_car_num, sk_net_num, insur_mng_name, insur_mng_phone, accident_url);
		AlimTemplateBean templateBean = atp_db.selectTemplate("acar0233");
    	String content = templateBean.getContent();
	  	for (String field : fieldList) {
    		content = content.replaceFirst("\\#\\{.*?\\}", field);
    	}
    	msg = content;
	}else if (msg_gubun.equals("accid_ins")){
		List<String> fieldList = Arrays.asList(insurance_name, insurance_name, insurance_phone, insur_mng_name, insur_mng_pos, insur_mng_phone, client.getFirm_nm(), cr_bean.getCar_no(), cm_bean.getCar_nm()+" "+cm_bean.getCar_name(), insur_info_url, sener_user_bean.getUser_nm(), sener_user_bean.getUser_pos(), sener_user_bean.getHot_tel());
		AlimTemplateBean templateBean = atp_db.selectTemplate("acar0089");
    	String content = templateBean.getContent();
	  	for (String field : fieldList) {
    		content = content.replaceFirst("\\#\\{.*?\\}", field);
    	}
    	msg = content;
	}else if (msg_gubun.equals("service")){
		List<String> fieldList = Arrays.asList(client.getFirm_nm(), car_service_info, insur_mng_name, insur_mng_phone);
		AlimTemplateBean templateBean = atp_db.selectTemplate("acar0204");
    	String content = templateBean.getContent();
	  	for (String field : fieldList) {
    		content = content.replaceFirst("\\#\\{.*?\\}", field);
    	}
    	msg = content;
	}
	
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function setSmsMsg(idx){
		var fm = document.form1;
		if(idx==1){
			opener.document.form1.txtMessage.value = fm.sms_msg2.value;
		}else if(idx==2 || idx==3 || idx==4 || idx==5 ){
			parent.document.form1.msg.value = fm.msg.value;
		}
		self.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='scd_size' value=''>
<input type='hidden' name='s_cnt' value='<%=s_cnt%>'>
<input type='hidden' name='h_fee_amt1' value=''>
<input type='hidden' name='h_dly_amt1' value=''>
<input type='hidden' name='h_fee_amt2' value=''>
<input type='hidden' name='h_dly_amt2' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�޽���<span class=style5> (<%if(msg_gubun.equals("accid")){%>���ó��<%}else if(msg_gubun.equals("park")){%>������<%}%>)</span></span></td>	
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>        
    <% if(msg_gubun.equals("mrent")){%>
      <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>����Ʈ �ȳ� ����</td>
                    <td colspan="3">&nbsp;
					            <textarea name='msg' rows='5' cols='65' class='text' readOnly style='IME-MODE: active'><%=msg%></textarea>
					            &nbsp;&nbsp;<a href="javascript:setSmsMsg(3);"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
    <%}else if(msg_gubun.equals("mrent1")){%>
      <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>����Ʈ �ȳ� ����1</td>
                    <td colspan="3">&nbsp;
					            <textarea name='msg' rows='5' cols='65' class='text' readOnly style='IME-MODE: active'><%=msg%></textarea>
					            &nbsp;&nbsp;<a href="javascript:setSmsMsg(3);"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
    <%}else if(msg_gubun.equals("mrent2")){%>
      <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>����Ʈ �ȳ� ����2</td>
                    <td colspan="3">&nbsp;
					            <textarea name='msg' rows='5' cols='65' class='text' readOnly style='IME-MODE: active'><%=msg%></textarea>
					            &nbsp;&nbsp;<a href="javascript:setSmsMsg(3);"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
    <%}else if(msg_gubun.equals("accid")){%>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>���ó��(�ܼ�����ó) �ȳ�</td>
                    <td colspan="3">&nbsp;
					            <textarea name='msg' rows='20' cols='72' class='text' readOnly style='IME-MODE: active'><%=msg%></textarea>
					            &nbsp;&nbsp;<a href="javascript:setSmsMsg(2);"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
    <%}else if(msg_gubun.equals("accid_ins")){%>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>�������� �� ���ó�� �ȳ�</td>
                    <td colspan="3">&nbsp;
					            <textarea name='msg' rows='20' cols='72' class='text' readOnly style='IME-MODE: active'><%=msg%></textarea>
					            &nbsp;&nbsp;<a href="javascript:setSmsMsg(5);"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	    
    <%}else if (msg_gubun.equals("service")){%>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>����(�Ϲݽ�)�ȳ�</td>
                    <td colspan="3">&nbsp;
					            <textarea name='msg' rows='20' cols='72' class='text' readOnly style='IME-MODE: active'><%=msg%></textarea>
					            &nbsp;&nbsp;<a href="javascript:setSmsMsg(4);"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	    
    <%}else if(msg_gubun.equals("park")){%>
    
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	
                <tr> 
                    <td class='title' width='15%' rowspan="2">������</td>
                    <td align=''>
                    		 &nbsp;&nbsp;<select name='sms_msg2'  onchange="setSmsMsg('1')">
                        <option value="">================����================</option>
						            <option value="������ ��ġ: ������ ����������
����� �������� �������� 34�� 9
TEL: 02-6263-6378 
�൵�ٷΰ����
http://fms1.amazoncar.co.kr/acar/images/center/map_s_youngnam.jpg
 ">������������:����������</option>
						            <option value="������ ��ġ: �λ����� ����Ʈ����2�� 
�λ� ������ �ݼ۷� 69
TEL: 051-851-0606 
�൵�ٷΰ����
http://fms1.amazoncar.co.kr/acar/images/center/hite.jpg 
 ">�λ�������:�λ����� ����Ʈ���� 3��</option>
						            <option value="������ ��ġ: ����ī��ũ 2�� 
������ ����� ���ɱ� 100 ����ī��ũ 2��
TEL: 042-824-1770 
�൵�ٷΰ����
http://fms1.amazoncar.co.kr/acar/images/center/dyd.jpg 
">����������:����ī��ũ 2��</option>
						            <option value="������ ��ġ: ������ (3M�ƽþƳ����) 
�뱸������ �޼��� �Ŵ絿321-86
TEL: 053-587-1550
�൵�ٷΰ����
http://fms1.amazoncar.co.kr/acar/images/center/gyg.jpg 
">�뱸������:������ (3M�ƽþƳ����)</option>
						            <option value="������ ��ġ: ��1���ڵ���������
���ֱ����� ���� �󹫴����� 131
TEL: 062-371-3444 
�൵�ٷΰ����
http://fms1.amazoncar.co.kr/acar/images/center/jyj_origin_com.jpg 
">����������:��1���ڵ���������</option>
                        </select>
        			 </td>
                </tr>
            </table>
        </td>
    </tr>	
   <%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
<% if(msg_gubun.equals("park")){%>

<%}else if(msg_gubun.equals("accid")){%>
	parent.document.form1.msg_subject.value = '[�Ƹ���ī ���ó�� �ȳ�]';	
	setSmsMsg(2);	
<%}else if(msg_gubun.equals("mrent")){%>
	parent.document.form1.msg_subject.value = '[�Ƹ���ī ����Ʈ �ȳ�]';
	setSmsMsg(3);	
<%}else if(msg_gubun.equals("mrent1")){%>
	parent.document.form1.msg_subject.value = '[�Ƹ���ī ����Ʈ �ȳ�1]';
	setSmsMsg(3);	
<%}else if(msg_gubun.equals("mrent2")){%>
	parent.document.form1.msg_subject.value = '[�Ƹ���ī ����Ʈ �ȳ�2]';
	setSmsMsg(3);	
<%}else if(msg_gubun.equals("service")){%>
	parent.document.form1.msg_subject.value = '[����(�Ϲݽ�) �ȳ�]';
	setSmsMsg(4);	
<%}else if(msg_gubun.equals("accid_ins")){%>
	parent.document.form1.msg_subject.value = '[�Ƹ���ī �������� �� ���ó�� �ȳ�]';
	setSmsMsg(5);	
<%}%>

//-->
</script>
</body>
</html>