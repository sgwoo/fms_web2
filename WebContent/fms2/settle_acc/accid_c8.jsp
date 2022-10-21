<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, tax.*"%>
<%@ page import="acar.accid.*, acar.res_search.*, acar.cont.*, acar.short_fee_mng.*, acar.user_mng.*,  acar.settle_acc.*, acar.estimate_mng.*,acar.ext.*"%>
<jsp:useBean id="oa_bean" class="acar.accid.OtAccidBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
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
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");//�������Ϸù�ȣ
	String mode = request.getParameter("mode")==null?"8":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//�����ȸ
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
		
	String bus_id2 = "";
	
	
	//����û����������Ʈ
	MyAccidBean my_r [] = as_db.getMyAccidList(c_id, accid_id);
	
	if(seq_no.equals("")) seq_no = "1";
	
	//����û������(����/������)
	MyAccidBean ma_bean = as_db.getMyAccid(c_id, accid_id, AddUtil.parseInt(seq_no));
		
		
	if ( !ma_bean.getBus_id2().equals("")){
	 	bus_id2 = ma_bean.getBus_id2();
	} else {
	    if ( !a_bean.getBus_id2().equals("") ) {  //�������� �����
	  	    bus_id2 = a_bean.getBus_id2();
	    } else {
			bus_id2 = (String)cont.get("BUS_ID2");
		}	
	}
	
	
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCaseAccid(c_id, accid_id);
	//��������
	Hashtable reserv = rs_db.getCarInfo(rc_bean.getCar_mng_id());
	
	//���ݰ�꼭 ��ȸ
	tax.TaxBean t_bean 		= IssueDb.getTax_accid(l_cd, c_id, accid_id, seq_no);
	
	Vector tax_vts = ScdMngDb.getEbHistoryList(t_bean.getTax_no());
	int tax_vt_size = tax_vts.size();
	String pubcode = "";
	if(tax_vt_size > 0){
		Hashtable tax_ht = (Hashtable)tax_vts.elementAt(tax_vt_size-1);
		pubcode = String.valueOf(tax_ht.get("PUBCODE"));
	}
	
	String car_st = String.valueOf(cont.get("CAR_NO"));
	if(!car_st.equals("")){
		if(car_st.indexOf("��") != -1){
			car_st = car_st.substring(4,5);	
		}
	}
	
	//������� ��������
	OtAccidBean oa_r [] = as_db.getOtAccid(c_id, accid_id);
	if(oa_r.length > 0){
		for(int i=0; i<1; i++){
   			oa_bean = oa_r[i];
			if(ma_bean.getIns_com().equals(""))		ma_bean.setIns_com	(oa_bean.getOt_ins());
			if(ma_bean.getIns_nm().equals(""))		ma_bean.setIns_nm	(oa_bean.getMat_nm());
			if(ma_bean.getIns_tel().equals(""))		ma_bean.setIns_tel	(oa_bean.getMat_tel());
		}
	}
	
	//û�������� ��ȸ
	TaxItemListBean ti = IssueDb.getTaxItemListMyAccid(c_id, accid_id, seq_no, ma_bean.getIns_req_amt());
	
	
	
	//�޴����� ���ݽ�����
	Hashtable ext6 = a_db.getScdExtEtcPay(m_id, l_cd, "6", accid_id+""+seq_no);
	if(AddUtil.parseInt(String.valueOf(ext6.get("PAY_AMT")))>0){
		ma_bean.setIns_pay_amt(AddUtil.parseInt(String.valueOf(ext6.get("PAY_AMT"))));
	}
	
	//����
	String d_var1 = e_db.getEstiSikVarCase("1", "", "myaccid_app1");//÷�μ���1
	String d_var2 = e_db.getEstiSikVarCase("1", "", "myaccid_app2");//÷�μ���2
	String d_var3 = e_db.getEstiSikVarCase("1", "", "myaccid_app3");//÷�μ���3
	String d_var4 = e_db.getEstiSikVarCase("1", "", "myaccid_app4");//÷�μ���4	
	String d_var5 = e_db.getEstiSikVarCase("1", "", "myaccid_app5");//÷�μ���5
	String d_var6 = e_db.getEstiSikVarCase("1", "", "myaccid_app6");//÷�μ���6
	String d_var7 = e_db.getEstiSikVarCase("1", "", "myaccid_app7");//÷�μ���7
	String d_var8 = e_db.getEstiSikVarCase("1", "", "myaccid_app8");//÷�μ���8
	String d_var9 = e_db.getEstiSikVarCase("1", "", "myaccid_app9");//÷�μ���9
	String d_var10 = e_db.getEstiSikVarCase("1", "", "myaccid_app10");//÷�μ���10
	
	
	String i_start_dt = ma_bean.getIns_use_st();
    String i_start_h 	= "00";
    String i_start_s 	= "00";
    String get_start_dt = ma_bean.getIns_use_st();
    if(get_start_dt.length() == 12){
    	i_start_dt 	= get_start_dt.substring(0,8);
    	i_start_h 	= get_start_dt.substring(8,10);
    	i_start_s	= get_start_dt.substring(10,12);
    }
	if(get_start_dt.length() == 8 && !rc_bean.getCar_mng_id().equals("") && get_start_dt.equals(rc_bean.getDeli_dt_d())){
		i_start_h 	= rc_bean.getDeli_dt_h();
    	i_start_s	= rc_bean.getDeli_dt_s();
	}
	String i_end_dt = ma_bean.getIns_use_et();
    String i_end_h 	= "00";
    String i_end_s 	= "00";
    String get_end_dt = ma_bean.getIns_use_et();
    if(get_end_dt.length() == 12){
    	i_end_dt 	= get_end_dt.substring(0,8);
    	i_end_h 	= get_end_dt.substring(8,10);
    	i_end_s		= get_end_dt.substring(10,12);
    }if(get_end_dt.length() == 8 && !rc_bean.getCar_mng_id().equals("") && get_end_dt.equals(rc_bean.getRet_dt_d())){
		i_end_h 	= rc_bean.getRet_dt_h();
    	i_end_s		= rc_bean.getRet_dt_s();
	}
	
	int ot_fault_per = ma_bean.getOt_fault_per();
	if(ot_fault_per==0) ot_fault_per = Math.abs(a_bean.getOur_fault_per()-100);
	
	Vector grts = ae_db.getExtScd(m_id, l_cd, "6");
	int grt_size = grts.size();
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form action="" name="form1">
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
  <input type='hidden' name='m_id' value='<%=m_id%>'>
  <input type='hidden' name='l_cd' value='<%=l_cd%>'>
  <input type='hidden' name='c_id' value='<%=c_id%>'>
  <input type='hidden' name='accid_id' value='<%=accid_id%>'>
  <input type='hidden' name='mode' value='<%=mode%>'>
  <input type='hidden' name='cmd' value='<%=cmd%>'>    
  <input type='hidden' name='go_url' value='<%=go_url%>'>
  <input type="hidden" name="client_id" value="<%=cont.get("CLIENT_ID")%>">
  <input type="hidden" name="site_id" value="">  
  <input type="hidden" name="rent_mng_id" value="<%=m_id%>">
  <input type="hidden" name="rent_l_cd" value="<%=l_cd%>">      
  <input type="hidden" name="car_mng_id" value="<%=c_id%>">      
  <input type="hidden" name="firm_nm" value="<%=cont.get("FIRM_NM")%>">     
  <input type='hidden' name='f_per' value='<%=Math.abs(a_bean.getOur_fault_per()-100)%>'>
  <input type='hidden' name='st' value=''>
  <input type="hidden" name="sender_id" value="<%=user_id%>">  	
  <input type="hidden" name="target_id" value="<%=nm_db.getWorkAuthUser("������")%>">  	
  <input type="hidden" name="coolmsg_sub" value="������û������ �߼ۿ�û">  	
  <input type="hidden" name="coolmsg_cont" value="�� ������û������ �����û :: <%=cont.get("FIRM_NM")%> <%=cont.get("CAR_NO")%>, ����Ͻ�:<%=a_bean.getAccid_dt()%>, û���ݾ�:<%=AddUtil.parseDecimal(ma_bean.getIns_req_amt())%>">  	
  <input type="hidden" name="seq_no" value="<%=seq_no%>">  	
  <input type='hidden' name="pubCode" value="">
  <input type='hidden' name="docType" value="">
  <input type='hidden' name="userType" value="">  
  <input type='hidden' name="item_id" value="<%=ti.getItem_id()%>">    
  <input type='hidden' name='ins_com_id' value=''>
  <input type='hidden' name='h_rent_start_dt' value=''>
  <input type='hidden' name='h_rent_end_dt' value=''>
	<%if(!rc_bean.getCar_mng_id().equals("")){%>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>������ȣ</td>
                    <td width=15%>&nbsp;<%=reserv.get("CAR_NO")%>
				  </td>
                    <td class=title width=10%>����</td>
                    <td width=15%>&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td>
                    <td class=title width=10%>�����Ͻ�</td>
                    <td width=15%>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
                    <td class=title width=10%>�����Ͻ�</td>
                    <td width=15%>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
	<%}%>		
    <tr> 
        <td>
            <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span>
		</td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>û������</td>
                    <td width=15%> 
                      <select name="ins_req_gu" disabled>
                        <option value="2" <%if(ma_bean.getIns_req_gu().equals("2"))%>selected<%%>>������</option>
                        <option value="1" <%if(ma_bean.getIns_req_gu().equals("1"))%>selected<%%>>������</option>
                      </select>
                    </td>
                    <td class=title width=10%>����</td>
                    <td width=15%> 
                      <select name="ins_req_st" disabled>
                        <option value="0" <%if(ma_bean.getIns_req_st().equals("0"))%>selected<%%>>��û��</option>
                        <option value="1" <%if(ma_bean.getIns_req_st().equals("1"))%>selected<%%>>û��</option>
                        <option value="2" <%if(ma_bean.getIns_req_st().equals("2"))%>selected<%%>>�Ϸ�</option>
                      </select>
                    </td>
                    <td class=title width=10%>������ȣ</td>
                    <td width=15%> 
                      <%=ma_bean.getIns_car_no()%>
                    </td>
                    <td class=title width=10%>����</td>
                    <td width=15%> 
                      <%=ma_bean.getIns_car_nm()%>
                  </td>
                </tr>
                <tr> 
                    <td class=title> �Ⱓ</td>
                    <td colspan="7"> 
                      <input type="text" name="ins_use_st" value="<%=AddUtil.ChangeDate2(i_start_dt)%>" size="11" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);' maxlength="10">

					  <select name="use_st_h" disabled>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(i_start_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="use_st_s" disabled>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(i_start_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>	

                      ~ 
                      <input type="text" name="ins_use_et" value="<%=AddUtil.ChangeDate2(i_end_dt)%>" size="11" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value); set_ins_use_dt();' maxlength="10">

					  <select name="use_et_h" disabled>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(i_end_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="use_et_s" disabled>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(i_end_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>	

                      ( 
					  <input type="text" name="use_hour" value="<%=ma_bean.getUse_hour()%>" size="2" class=whitenum onBlur='javscript:set_ins_amt();'>
                      �ð� 	

                      <input type="text" name="ins_use_day" value="<%=ma_bean.getIns_use_day()%>" size="3" class=whitenum onBlur='javscript:set_ins_amt();'>
                      ��					  
					  )&nbsp; 
        			  </td>                    
                </tr>
                <tr> 
                    <td class=title>û������</td>
                    <td> 1�� 
                      <%=AddUtil.parseDecimal(ma_bean.getIns_day_amt())%>��</td>
                    <td class=title>������</td>
                    <td><%=ot_fault_per%>%</td>
                    <td class=title>û������</td>
                    <td><%=AddUtil.ChangeDate2(ma_bean.getIns_req_dt())%> </td>
                    <td class=title>û����</td>
                    <td>&nbsp;
                        <select name='bus_id2' disabled>
                          <option value="">������</option>
                          <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                          <option value='<%=user.get("USER_ID")%>' <%if(bus_id2.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                          <%		}
        					}		%>
                        </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>û���ݾ�</td>
                  <td>
                      <%=AddUtil.parseDecimal(ma_bean.getIns_req_amt())%>��
					  </td>
                  <td class=title>���ް�</td>
                  <td><%=AddUtil.parseDecimal(ma_bean.getMc_s_amt())%>�� </td>
                  <td class=title>�ΰ���</td>
                  <td colspan="3"><%=AddUtil.parseDecimal(ma_bean.getMc_v_amt())%>�� </td>
                </tr>												
                <tr> 				
                    <td class=title>��û������</td>
                    <td colspan="7"><%=ma_bean.getRe_reason()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>�Աݱ���</td>
                  <td width=15%><select name="pay_gu" disabled>
				    <option value="" <%if(ma_bean.getPay_gu().equals(""))%>selected<%%>>����</option>
                    <option value="2" <%if(ma_bean.getPay_gu().equals("2"))%>selected<%%>>������</option>
                    <option value="1" <%if(ma_bean.getPay_gu().equals("1"))%>selected<%%>>������</option>
                  </select></td>
                    <td class=title width=10%>�Աݱݾ�</td>
                    <td width=15%><%=AddUtil.parseDecimal(ma_bean.getIns_pay_amt())%>�� 
                    </td>
                    <td class=title width=10%>�Ա�����</td>
                    <td width=40%><%=AddUtil.ChangeDate2(ma_bean.getIns_pay_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>�����</td>
                    <td colspan="3"><%=ma_bean.getIns_com()%></td>
                    <td class=title>������ȣ</td>
                    <td colspan="3">NO.<%=ma_bean.getIns_num()%></td>
                </tr>		
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=15%><%=ma_bean.getIns_nm()%></td>
                    <td class=title width=10%>����ó��</td>
                    <td width=15%><%=ma_bean.getIns_tel()%></td>
                    <td class=title width=10%>����ó��</td>
                    <td width=15%><%=ma_bean.getIns_tel2()%></td>
                    <td class=title width=10%>�ѽ�</td>
                    <td width=15%><%=ma_bean.getIns_fax()%></td>
                </tr>
                <tr> 
                    <td class=title>�ּ�</td>
                    <td colspan="7"><%=ma_bean.getIns_zip()%> <%=ma_bean.getIns_addr()%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>���</td>
                    <td colspan="7"><%=ma_bean.getIns_etc()%></td>
                </tr>
            </table>
        </td>
    </tr>
	<%
		Vector settles = s_db.getInsurHReqDocHistoryList(c_id, accid_id, seq_no);
		int settle_size = settles.size();%>
	<%	if(settle_size > 0){%>
    <tr>
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������û������</span>
		</td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr> 
        <td class="line" colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            	  <tr> 
            	    <td class='title' width=5%> ����</td>
		            <td class='title' width="15%">������ȣ</td>
		            <td class='title' width="15%">��������</td>
		            <td class='title' width="40%">����</td>
		            <td class='title' width="15%">����</td>
		            <td class='title' width="10%">�����</td>					
		          </tr>          
                </tr>
        		<%	for (int i = 0 ; i < settle_size ; i++){
						Hashtable settle = (Hashtable)settles.elementAt(i);%>		  
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td align='center'><a href="javascript:FineDocPrint('<%=settle.get("DOC_ID")%>')" onMouseOver="window.status=''; return true"><%=settle.get("DOC_ID")%></a></td>
			        <td align='center'><%=settle.get("DOC_DT")%></td>
			        <td align='center'><%=settle.get("GOV_NM")%></td>
			        <td align='center'><%=settle.get("MNG_DEPT")%> <%=settle.get("MNG_NM")%> <%=settle.get("MNG_POS")%></td>			
			        <td align='center'><%=settle.get("USER_NM")%></td>								
                </tr>
          		<%	}%>
            </table>
        </td>
    </tr>
	<%	}%>
    <tr>
		<td class=h></td>
	</tr> 	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݽ�����</span></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10%  class='title'>ȸ��</td>
                    <td width=15% class='title'>���ް�</td>
                    <td width=15% class='title'>�ΰ���</td>
                    <td width=15% class='title'>�հ�</td>
                    <td width=15% class='title'>�Աݿ�����</td>
                    <td width=15% class='title'>�Ա���</td>
                    <td width=15% class='title'>�Աݾ�</td>
                </tr>
          <%		for(int i = 0 ; i < grt_size ; i++){
			ExtScdBean grt = (ExtScdBean)grts.elementAt(i);
			if(!grt.getExt_pay_dt().equals("")){%>
                <tr> 
                    <td align='center'><%=grt.getExt_tm()%>ȸ<%if(!grt.getExt_tm().equals("1")){%>(�ܾ�)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%>��&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%>��&nbsp;</td>
                    <td align='right'><input type='text' name='t_grt_amt' value='<%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' class='whitenum' readonly size="10">
        			��&nbsp;</td>
                    <td align='center'> <input type='text' name='t_grt_est_dt' size='11' value='<%=grt.getExt_est_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                    <td align='center'> <input type='text' name='t_grt_pay_dt' size='11' value='<%=grt.getExt_pay_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td align='right'> <input type='text' name='t_grt_pay_amt' size='10' class='whitenum' maxlength='10' value='<%=Util.parseDecimal(grt.getExt_pay_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                </tr>
          <%			}else{%>
                <tr> 
                    <td align='center'><%=grt.getExt_tm()%>ȸ<%if(!grt.getExt_tm().equals("1")){%>(�ܾ�)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%>��&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%>��&nbsp;</td>
                    <td align='right'> <input type='text' name='t_grt_amt' value='<%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' class='whitenum' readonly size="10">
                      ��&nbsp;</td>
                    <td align='center'> <input type='text' name='t_grt_est_dt' size='11' value='<%=grt.getExt_est_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                    <td align='center'> <input type='text' name='t_grt_pay_dt' size='11' value='<%=grt.getExt_pay_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td align='right'> <input type='text' name='t_grt_pay_amt' size='10' class='whitenum' maxlength='10' value='' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>			
                </tr>
          <%			}
		}%>
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
        <td align=right><a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a></td>
    </tr>    	
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
