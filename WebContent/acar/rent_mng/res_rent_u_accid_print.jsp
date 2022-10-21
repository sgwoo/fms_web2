<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*, acar.accid.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"c.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	String reg_dt = Util.getDate();
	
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "05", "02");
	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String sub_c_id = request.getParameter("sub_c_id")==null?"":request.getParameter("sub_c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	
	String disabled = "disabled";
	String white = "white";
	String readonly = "readonly";
	if(mode.equals("u")){
		disabled = "";
		white = "";
		readonly = "";
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	
	Vector users = c_db.getUserList("", "", "EMP"); //����� ����Ʈ
	int user_size = users.size();	

	//����� ����Ʈ
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;	
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	RentCustBean rc_bean3 = rs_db.getRentCustCase2(rc_bean.getCust_st(), rc_bean.getCust_id(), rc_bean.getRent_s_cd());
	//�ܱ������-���뺸����
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
	
	//����������
	ScdRentBean sr_bean1 = rs_db.getScdRentCase(s_cd, "1");
	ScdRentBean sr_bean2 = rs_db.getScdRentCase(s_cd, "2");
	String rent_st = rc_bean.getRent_st();
	String use_st = rc_bean.getUse_st();
	
	String print_car_no = "";
	String print_car_nm = "";
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	MyAccidBean ma_bean = new MyAccidBean();
	if(mode.equals("accid_doc")){
		ma_bean = as_db.getMyAccid(sub_c_id, accid_id, AddUtil.parseInt(seq_no));
	}
	
	UsersBean bus_bean 	= umd.getUsersBean(rc_bean.getBus_id());
	
	
	String i_start_dt = ma_bean.getIns_use_st();
    	String i_start_h 	= "00";
    	String i_start_s 	= "00";
    	String get_start_dt = ma_bean.getIns_use_st();
    	if(get_start_dt.length() == 12){
    		i_start_dt 	= get_start_dt.substring(0,8);
    		i_start_h 	= get_start_dt.substring(8,10);
    		i_start_s	= get_start_dt.substring(10,12);
    	}
	String i_end_dt = ma_bean.getIns_use_et();
    	String i_end_h 	= "00";
    	String i_end_s 	= "00";
    	String get_end_dt = ma_bean.getIns_use_et();
    	if(get_end_dt.length() == 12){
    		i_end_dt 	= get_end_dt.substring(0,8);
    		i_end_h 	= get_end_dt.substring(8,10);
    		i_end_s		= get_end_dt.substring(10,12);
    	}		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
</head>
<body>
<form action="" name="form1" method="post" >
<input type='hidden' name='s_cd' value='<%=s_cd%>'>				
<table border=0 cellspacing=0 cellpadding=0 width=650>
    <tr colspan=2>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
				<td><center><font size="<%if(mode.equals("accid_doc") || mode.equals("res_doc")){%>4<%}else{%>6<%}%>" face="�ü�ü">>>
                    <%if(rent_st.equals("1")){%>
                    �ܱ�뿩 
                    <%}else if(rent_st.equals("2")){%>
                    ������� 
                    <%}else if(rent_st.equals("3")){%>
                    ������ 
                    <%}else if(rent_st.equals("9")){%>
                    ������� 
                    <%}else if(rent_st.equals("10")){%>
                    �������� 		
                    <%}else if(rent_st.equals("4")){%>
                    �����뿩 
                    <%}else if(rent_st.equals("5")){%>
                    �������� 
                    <%}else if(rent_st.equals("6")){%>
                    �������� 
                    <%}else if(rent_st.equals("7")){%>
                    �������� 
                    <%}else if(rent_st.equals("8")){%>
                    ������ 
                    <%}else if(rent_st.equals("11")){%>
                    ��Ÿ 
                    <%}else if(rent_st.equals("12")){%>
                    ����Ʈ
                    <%}%> ���� ��༭ <<
                </font>
                </center>
					</td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>			
        <td align="right">&nbsp;</td>			
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
        <td align="right">&nbsp;</td>			
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="15%" class=title>������ȣ</td>
                  <td colspan="3">&nbsp;<input name="car_no" type="text" class="whitetext" value="<%=reserv.get("CAR_NO")%>" size="15"></td>
                </tr>
                <tr>
                  <td width="15%" class=title>����</td>
                  <td colspan="3">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%> (<%=reserv.get("SECTION")%>)</td>
                </tr>				
                <tr>
                  <td width="15%" class=title>���ʵ����</td>
                  <td width="35%">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
                  <td width="15%" class=title>�����ȣ</td>
                  <td width="35%">&nbsp;<%=reserv.get("CAR_NUM")%></td>
                </tr>
                <tr>
                  <td width="15%" class=title>�������</td>
                  <td width="35%">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("DLV_DT")))%></td>
                  <td width="15%" class=title>��ⷮ</td>
                  <td width="35%">&nbsp;<%=reserv.get("DPM")%>cc</td>
                </tr>
                <tr>
                  <td width="15%" class=title>Į��</td>
                  <td width="35%">&nbsp;<%=reserv.get("COLO")%></td>
                  <td width="15%" class=title>����</td>
                  <td width="35%">&nbsp;<%=reserv.get("FUEL_KD")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_cust_nm style="display:<%if(rent_st.equals("1")||rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("4")||rent_st.equals("5")||rent_st.equals("9")||rent_st.equals("10")||rent_st.equals("12")) {%>''<%}else{%>none<%}%>"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
        <td align="right"><a href='javascript:save();'></a></td>
    </tr>
    <%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="15%" class=title>����</td>
                  <td colspan="3">&nbsp;<%=rc_bean2.getCust_st()%> </td>
                </tr>
                <tr> 
                    <td width="15%" class=title>��ȣ
        			</td>
                    <td colspan="3">&nbsp; <%=rc_bean2.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td width="15%" class=title>����</td>
                    <td colspan="3">&nbsp;<%=rc_bean2.getCust_nm()%></td>
                </tr>
                <tr> 
                    <td width="15%" class=title>����ڹ�ȣ</td>
                    <td width="35%">&nbsp;<%=rc_bean2.getEnp_no()%> </td>
                    <td width="15%" class=title><%if(!rc_bean2.getCust_st().equals("����")) {%>������� <%}else{%>���ι�ȣ <%}%></td>
                    <td width="35%">&nbsp;<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%></td>
                </tr>
                <tr> 
                    <td width="15%" class=title>�ּ�</td>
                    <td colspan="3"> 
                        &nbsp;<%=rc_bean2.getZip()%>
                        &nbsp; 
                        <%=rc_bean2.getAddr()%>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=15%>�����ȣ</td>
                    <td> 
                        &nbsp;<%=rc_bean2.getLic_no()%>
                    </td>
                    <td class=title>��������</td>
                    <td>&nbsp;<%=rc_bean2.getLic_st()%>  
                    </td>
                </tr>
                <tr>
                  <td width="15%" class=title>��ȭ��ȣ</td>
                  <td>&nbsp;<%=rc_bean2.getTel()%> </td>
                  <td class=title>�޴���</td>
                  <td>&nbsp;<%=rc_bean2.getM_tel()%> </td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("2") || rent_st.equals("3") || rent_st.equals("10")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td width="15%" class=title>����</td>
                <td colspan="3">&nbsp;<%=rc_bean2.getCust_st()%> </td>
              </tr>
                <tr> 
                    <td width="15%" class=title>��ȣ
        			</td>
                    <td colspan="3">&nbsp; <%=rc_bean2.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td width="15%" class=title>����</td>
                    <td colspan="3">&nbsp;<%=rc_bean2.getCust_nm()%></td>
                </tr>			  
              <tr>
                <td width="15%" class=title>����ڹ�ȣ</td>
                <td width="35%">&nbsp;<%=rc_bean2.getEnp_no()%> </td>
                <td width="15%" class=title><%if(!rc_bean2.getCust_st().equals("����")) {%>
                  �������
                    <%}else{%>
                    ���ι�ȣ
                    <%}%>
                </td>
                <td width="35%">&nbsp;<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%> </td>
              </tr>
              <tr>
                <td class=title>������ּ�</td>
                <td colspan="3">&nbsp;<%=rc_bean2.getZip()%> &nbsp; <%=rc_bean2.getAddr()%> </td>
              </tr>
              <tr>
                <td class=title>��ȭ��ȣ</td>
                <td>&nbsp;<%=rc_bean2.getTel()%> </td>
                <td class=title>�޴���</td>
                <td>&nbsp;<%=rc_bean2.getM_tel()%> </td>
              </tr>
            </table></td>
    </tr>	
    <input type='hidden' name='c_zip' value=''>				
    <input type='hidden' name='c_addr' value=''>	
    <input type='hidden' name='c_lic_no' value=''>				
    <input type='hidden' name='c_lic_st' value=''>	
    <input type='hidden' name='c_tel' value=''>				
    <input type='hidden' name='c_m_tel' value=''>		
    <%}else if(rent_st.equals("4") || rent_st.equals("5")){%>
    <input type='hidden' name='c_firm_nm' value='(��)�Ƹ���ī'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>����</td>
                    <td width=35%> 
                        &nbsp;�Ƹ���ī ����
                    </td>
                    <td class=title width=15%>����</td>
                    <td width=35%> 
                        &nbsp;<select name='c_cust_nm' onChange='javascript:user_select()' <%=disabled%>>
                            <option value="">==����==</option>			  
                            <%	if(user_size > 0){
            						for (int i = 0 ; i < user_size ; i++){
            							Hashtable user = (Hashtable)users.elementAt(i);	%>
                            <option value='<%=user.get("USER_ID")%>'  <%if(rc_bean2.getCust_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                            <%		}
            					}		%>
                        </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%}else{%>
    <input type='hidden' name='c_cust_st' value='5'>	
    <input type='hidden' name='c_cust_nm' value=''>
    <input type='hidden' name='c_firm_nm' value=''>	
    <input type='hidden' name='c_ssn' value=''>
    <input type='hidden' name='c_enp_no' value=''>
    <input type='hidden' name='c_lic_no' value=''>				
    <input type='hidden' name='c_lic_st' value=''>
    <input type='hidden' name='c_zip' value=''>				
    <input type='hidden' name='c_addr' value=''>	
	<%}%>
    <tr><td class=h></td></tr>
	<%if(rent_st.equals("10")){
		//������������
		Hashtable serv = rs_db.getInfoTeacha2(rc_bean.getSub_l_cd(), String.valueOf(reserv.get("CAR_NO")));
		if(String.valueOf(serv.get("CAR_NM")).equals("null")){
			serv = rs_db.getInfoTeacha(rc_bean.getCust_id(), String.valueOf(reserv.get("CAR_NO")));
		}
		print_car_no = String.valueOf(serv.get("CAR_NO"));
		print_car_nm = String.valueOf(serv.get("CAR_NM"));
		if(print_car_no.equals("null")){ print_car_no="";}
		if(print_car_nm.equals("null")){ print_car_nm="";}
	%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100% >
                <tr>
                  <td width="15%" class=title style='height:38'>������ȣ</td>
                  <td width="35%">&nbsp;
				  <%=print_car_no%></td>
                  <td width="15%" class=title>����</td>
                  <td width="35%">&nbsp;
                  <%=print_car_nm%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>	
	<%}else if(rent_st.equals("2")){
		//�����������
		Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="15%" style='height:38'>�������</td>
                    <td colspan="3"> 
                        &nbsp;
						<%=serv.get("OFF_NM")==null?"":serv.get("OFF_NM")%>
                    </td>
                </tr>
                <tr>
                  <td width="15%" class=title style='height:38'>����������ȣ</td>
                  <td width="35%">&nbsp;
				  <%=serv.get("CAR_NO")==null?"":serv.get("CAR_NO")%></td>
                  <td width="15%" class=title>����</td>
                  <td width="35%">&nbsp;
                  <%=serv.get("CAR_NM")==null?"":serv.get("CAR_NM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>	
	<%}else if(rent_st.equals("3")){
		//����������
		Hashtable accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id());
		
		if(mode.equals("accid_doc") && !seq_no.equals("")) accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id(), seq_no);%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="15%" class=title>�������</td>
                  <td colspan="3">&nbsp;
				  <input name="off_nm" type="text" class="whitetext" value="<%=accid.get("OFF_NM")==null?"":accid.get("OFF_NM")%>" size="80"></td>
                </tr>
                <tr> 
                    <td class=title width=15%>����������ȣ</td>
                    <td width=35%>&nbsp;<input name="a_car_no" type="text" class="whitetext" value="<%=accid.get("CAR_NO")==null?"":accid.get("CAR_NO")%>" size="30">
                  </td>
                    <td class=title width=15%>����</td>
                    <td width=35%>&nbsp;<input name="a_car_nm" type="text" class="whitetext" value="<%=accid.get("CAR_NM")==null?"":accid.get("CAR_NM")%>" size="30">
                    </td>
                </tr>
                <tr> 
                    <td width="15%" class=title> ������ȣ</td>
                    <td width="35%"> 
                      &nbsp;<input name="a_p_num" type="text" class="whitetext" value="<%=accid.get("P_NUM")==null?"":accid.get("P_NUM")%>" size="30">
                    </td>
                    <td width="15%" class=title>�����ں����</td>
                    <td width="35%"> 
                      &nbsp;<input name="a_g_ins" type="text" class="whitetext" value="<%=accid.get("G_INS")==null?"":accid.get("G_INS")%>" size="30">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
	<%}else if(rent_st.equals("9")){
		//�����������
		RentInsBean ri_bean = rs_db.getRentInsCase(s_cd);%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="15%" class=title> ������ȣ</td>
                    <td width="20%"> 
                      &nbsp;<%=ri_bean.getIns_num()%>
                    </td>
                    <td width="10%" class=title>�����</td>
                    <td width="30%"> 
                      &nbsp;<select name='ins_com_id' <%=disabled%>>
                        <%if(ic_size > 0){
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>" <%if(ri_bean.getIns_com_id().equals(ic.getIns_com_id()))%>selected<%%>><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td width="10%" class=title> �����</td>
                    <td width="15%">&nbsp;
                        <%=ri_bean.getIns_nm()%>
                    </td>
                </tr>
                <tr>
                  <td width="15%" class=title>����ó��</td>
                  <td>&nbsp;
                      <%=ri_bean.getIns_tel()%>
                  </td>
                  <td width="10%" class=title>����ó��</td>
                  <td>&nbsp;
                      <%=ri_bean.getIns_tel2()%>
                  </td>
                  <td width="10%" class=title>�ѽ�</td>
                  <td>&nbsp;
                      <%=ri_bean.getIns_fax()%>
                  </td> 
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>		
	<%}else if(rent_st.equals("6")){
		//������������
		Hashtable serv = rs_db.getInfoServ(c_id, rc_bean.getServ_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>
        			�������</td>
                    <td width=35%> 
                      &nbsp;<%=serv.get("OFF_NM")%>
                  </td>
                    <td class=title width=15%> ��������</td>
                    <td width=35%>
                      &nbsp;<%=AddUtil.ChangeDate2(String.valueOf(serv.get("SERV_DT")))%>
                  </td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr><td class=h></td></tr>	
	<%}else if(rent_st.equals("7")){
		//������������
		Hashtable maint = rs_db.getInfoMaint(c_id, rc_bean.getMaint_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>�˻���ȿ�Ⱓ</td>
                    <td width=85%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%> 
                  </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
	<%}else if(rent_st.equals("8")){
		//����������
		Hashtable accid = rs_db.getInfoAccid(c_id, rc_bean.getAccid_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15% style='height:37'>
        			�������</td>
                    <td width=35%> 
                      &nbsp;<%=accid.get("OFF_NM")%>
                  </td>
                    <td class=title width=10%>�������</td>
                    <td width=20%> 
                      &nbsp;<%=AddUtil.ChangeDate2(String.valueOf(accid.get("ACCID_DT")))%>
                  </td>
                    <td class=title width=10%>�����</td>
                    <td width=10%> 
                      &nbsp;<%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%>
                  </td>
                </tr>
                <tr> 
                    <td width="15%" class=title> �����</td>
                    <td colspan="5"> 
                      &nbsp;<%=accid.get("ACCID_CONT")%>&nbsp;<%=accid.get("ACCID_CONT2")%>
                    </td>
                </tr>
          </table>
        </td>
    </tr>		
	<%}%>
	<tr><td class=h></td></tr>					
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
	    <td align="right"><font color="#999999">
        </font></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>		  				
                <tr> 
                    <td class=title width=15%>�������</td>
                    <td width=20%>&nbsp;
					  <%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%></td>
                    <td class=title width=10%>������</td>
                    <td width=25%><input type='hidden' name='s_brch_id' value='<%=rc_bean.getBrch_id()%>'> 
                      &nbsp;<%=bus_bean.getBr_nm()%>
                    </td>
                    <td width=10% class=title>�����</td>
                    <td width="20%"><input type='hidden' name='bus_id' value='<%=rc_bean.getBus_id()%>'> 
                      &nbsp;<%=bus_bean.getUser_nm()%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��Ÿ</td>
                    <td colspan="5"> 
                      &nbsp;<%=rc_bean.getEtc()%>
                    </td>
                </tr>		  
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����/����</span></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="15%" class=title>����������</td>
                    <td width="35%"> 
                      &nbsp;<%=AddUtil.ChangeDate2(rc_bean.getDeli_plan_dt_d())%>
                    </td>
                    <td width="15%" class=title>����������</td>
                    <td width="35%"> 
                      &nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%>
                    </td>
                </tr>
                <%if(rent_st.equals("3") && !i_start_dt.equals("")){%>
                <tr> 
                    <td class=title width=15%>��������</td>
                    <td width=35%> 
                      &nbsp;<%=AddUtil.ChangeDate2(i_start_dt)%>&nbsp;<%=i_start_h%>��<%=i_start_s%>��
                    </td>
                    <td class=title width=15%>��������</td>
                    <td width=35%>
                      &nbsp;<%=AddUtil.ChangeDate2(i_end_dt)%>&nbsp;<%=i_end_h%>��<%=i_end_s%>��
        			</td>
                </tr>
                <%}else{%>
                <tr> 
                    <td class=title width=15%>��������</td>
                    <td width=35%> 
                      &nbsp;<%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%>&nbsp;<%=i_start_h%>��<%=i_start_s%>��
                    </td>
                    <td class=title width=15%>��������</td>
                    <td width=35%>
                      &nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%>&nbsp;<%=i_end_h%>��<%=i_end_s%>��
        			</td>
                </tr>
                <%}%>
                <tr> 
                    <td width="15%" class=title>������ġ</td>
                    <td width="35%"> 
                      &nbsp;<%=rc_bean.getDeli_loc()%>
                    </td>
                    <td width="15%" class=title>������ġ</td>
                    <td width="35%">
					  &nbsp;<%=rc_bean.getRet_loc()%>
					</td>
                </tr>
          </table>
        </td>
    </tr>
<!-- ������ ȭ�� ��� ��� ��û�ؼ� �ӽ÷� �۾���. 2009-05-08 ���⼭ ����-->    
	<tr>
		<td height=15></td>
	</tr>
	<%if(mode.equals("res_doc")){%>
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;&nbsp;�� ���� <b><input name="car_no2" type="text" class="whitetext" value="<%=reserv.get("CAR_NO")%>" size="12"> <%=reserv.get("CAR_NM")%>  </b>������ 
		
					<%if(rent_st.equals("1")){%>
                    �ܱ�뿩 
                    <%}else if(rent_st.equals("2")){%>
                    ������� 
                    <%}else if(rent_st.equals("3")){%>
                    ������ 
                    <%}else if(rent_st.equals("9")){%>
                    ������� 
                    <%}else if(rent_st.equals("10")){%>
                    �������� 		
                    <%}else if(rent_st.equals("4")){%>
                    �����뿩 
                    <%}else if(rent_st.equals("5")){%>
                    �������� 
                    <%}else if(rent_st.equals("6")){%>
                    �������� 
                    <%}else if(rent_st.equals("7")){%>
                    �������� 
                    <%}else if(rent_st.equals("8")){%>
                    ������ 
                    <%}else if(rent_st.equals("11")){%>
                    ��Ÿ 
                    <%}else if(rent_st.equals("12")){%>
                    ����Ʈ
                    <%}%> ���񽺸�
		
		 <b><%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%> ~ <p>&nbsp;&nbsp;&nbsp;<%if(!rc_bean.getRet_dt_d().equals("")){%><%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%><%}else{%><%=reg_dt%><%}%></b> ���� ���� �Ͽ����� ������.
    	</td>
    </tr>	
	<%}else{%>
	<%
			Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());
			
			if(print_car_no.equals("")){
				print_car_no = String.valueOf(serv.get("CAR_NO"));
				print_car_nm = String.valueOf(serv.get("CAR_NM"));
			}
			if(print_car_no.equals("null")){ print_car_no="";}
			if(print_car_nm.equals("null")){ print_car_nm="";}
	%>
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;&nbsp;�� ���� <input name="car_no2" type="text" class="whitetext" value="<%=print_car_no%>" size="12"> <b><%=print_car_nm%></b> ������ 
		<input name="rent_st_nm" type="text" class="whitetext" value="�����" size="12"> �Ͽ� �̿��ϴ��� ���� ���񽺸� 		
		<p>&nbsp;&nbsp;&nbsp;
			<%if(rent_st.equals("3") && !i_start_dt.equals("")){%>
				<b><%=AddUtil.ChangeDate2(i_start_dt)%>&nbsp;<%=i_start_h%>��<%=i_start_s%>�� ~
				<%if(!i_end_dt.equals("")){%><%=AddUtil.ChangeDate2(i_end_dt)%><%}else{%><%=reg_dt%><%}%>&nbsp;<%=i_end_h%>��<%=i_end_s%>��		 
			<%}else{%>
				<b><%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%>&nbsp;<%=i_start_h%>��<%=i_start_s%>�� ~
				<%if(!rc_bean.getRet_dt_d().equals("")){%><%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%><%}else{%><%=reg_dt%><%}%>&nbsp;<%=i_end_h%>��<%=i_end_s%>��		 
			<%}%>
		����</b>
		<input name="car_no3" type="text" class="whitetext" value="<%=reserv.get("CAR_NO")%>" size="12"> �������� ���� �Ͽ����� ������.
    	</td>
    </tr>	
	<%}%>
	<tr>
		<td align=right><img src=/acar/images/pay_h_ceo.gif></td>
	</tr>    
<!-- ������� -->	   
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>

