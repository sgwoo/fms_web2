<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<%
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector branches = c_db.getBranchList(); //������ ����Ʈ ��ȸ
	int brch_size = branches.size();
	
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
	//�ܱ������-���뺸����
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
	
	//����������
	ScdRentBean sr_bean1 = rs_db.getScdRentCase(s_cd, "1");
	ScdRentBean sr_bean2 = rs_db.getScdRentCase(s_cd, "2");
	String rent_st = rc_bean.getRent_st();
	String use_st = rc_bean.getUse_st();
	//������
	Vector exts = rs_db.getRentContExtList(s_cd);
	int ext_size = exts.size();
	
%>
<form action="res_rent_u_a.jsp" name="form1" method="post" >

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > <span class=style5> <%if(rent_st.equals("1")){%>
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
                    ����� 
                    <%}else if(rent_st.equals("12")){%>
                    ����Ʈ
                    <%}%></span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>   
    <tr id=tr_cust_nm style="display:<%if(rent_st.equals("1")||rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("4")||rent_st.equals("5")||rent_st.equals("9")||rent_st.equals("10")||rent_st.equals("11")||rent_st.equals("12")) {%>''<%}else{%>none<%}%>"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
        <td align="right"> <a href='javascript:save();'> </a></td>
    </tr>
    <%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>����</td>
                    <td>&nbsp;<%=rc_bean2.getCust_st()%></td>
                    <td class=title>����</td>
                    <td colspan="3">&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class=title>�������</td>
                    <td>&nbsp;<%if(!nm_db.getWorkAuthUser("�Ƹ���ī�̿�",ck_acar_id)){%><%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%><%}%></td>
                </tr>
                <tr> 
                    <td class=title>��ȣ</td>
                    <td colspan="5">&nbsp;<%=rc_bean2.getFirm_nm()%></td>
                    <td class=title>����ڵ�Ϲ�ȣ</td>
                    <td>&nbsp;<%=rc_bean2.getEnp_no()%></td>
                </tr>
				<tr> 
                    <td class=title>�繫�ǹ�ȣ</td>
                    <td colspan="5">&nbsp;<%=rc_bean2.getTel()%></td>
                    <td class=title>�޴�����ȣ</td>
                    <td>&nbsp;<%=rc_bean2.getM_tel()%></td>
                </tr>
                <tr> 
                    <td class=title>�ּ�</td>
                    <td colspan="7">&nbsp;<%=rc_bean2.getZip()%>&nbsp;<%=rc_bean2.getAddr()%> 
                    </td>
                </tr>
                <tr> 
                    <td class=title width=11%>���������ȣ</td>
                    <td width=16%>&nbsp;<%if(!nm_db.getWorkAuthUser("�Ƹ���ī�̿�",ck_acar_id)){%><%=rc_bean2.getLic_no()%><%}%></td>
                    <td class=title width=10%>��������</td>
                    <td width=14%>&nbsp;<%=rc_bean2.getLic_st()%></td>
                    <td class=title width=10%>��ȭ��ȣ</td>
                    <td width=14%>&nbsp;<%=rc_bean2.getTel()%></td>
                    <td class=title width=12%>�޴���</td>
                    <td width=13%>&nbsp;<%=rc_bean2.getM_tel()%></td>
                </tr>
                <tr> 
                    <td class=title>��󿬶�ó</td>
                    <td  colspan='7'>&nbsp;����:&nbsp;<%=rm_bean2.getMgr_nm()%> &nbsp;&nbsp; 
                      ����ó:&nbsp;<%=rm_bean2.getTel()%> &nbsp; ����:&nbsp;<%=rm_bean2.getEtc()%> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("2") || rent_st.equals("3") || rent_st.equals("10") || rent_st.equals("11")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=11%>����</td>
                    <td width=22%>&nbsp;<%=rc_bean2.getCust_st()%></td>
                    <td class=title width=11%>����</td>
                    <td width=22%>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class=title width=12%>�������</td>
                    <td width=22%>&nbsp;<%if(!nm_db.getWorkAuthUser("�Ƹ���ī�̿�",ck_acar_id)){%><%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%><%}%></td>
                </tr>
                <tr> 
                    <td class=title>��ȣ</td>
                    <td colspan="3">&nbsp;<%=rc_bean2.getFirm_nm()%></td>
                    <td class=title>����ڵ�Ϲ�ȣ</td>
                    <td>&nbsp;<%=rc_bean2.getEnp_no()%></td>
                </tr>
				<tr> 
                    <td class=title>�繫�ǹ�ȣ</td>
                    <td colspan="3">&nbsp;<%=rc_bean2.getTel()%></td>
                    <td class=title>�޴�����ȣ</td>
                    <td>&nbsp;<%=rc_bean2.getM_tel()%></td>
                </tr>
				<tr> 
                    <td class=title>�ּ�</td>
                    <td colspan="7">&nbsp;<%=rc_bean2.getZip()%>&nbsp;<%=rc_bean2.getAddr()%> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("4") || rent_st.equals("5")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=11%>����</td>
                    <td width=15%>&nbsp;����</td>
                    <td class=title width=10%>����</td>
                    <td width=14%> 
                      &nbsp;<select name='c_cust_nm' onChange='javascript:user_select()' disabled>
                        <option value="">==����==</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>'  <%if(rc_bean2.getCust_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                    <td class=title width=10%>�����Ҹ�</td>
                    <td width=15%>&nbsp;<%=rc_bean2.getBrch_nm()%></td>
                    <td class=title width=10%>�μ���</td>
                    <td  width=15%>&nbsp;<%=rc_bean2.getDept_nm()%></td>
                </tr>
                <tr> 
                    <td class=title>���������ȣ</td>
                    <td>&nbsp;<%=rc_bean2.getLic_no()%></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<%=rc_bean2.getLic_st()%></td>
                    <td class=title>��ȭ��ȣ</td>
                    <td>&nbsp;<%=rc_bean2.getTel()%></td>
                    <td class=title>�޴���</td>
                    <td>&nbsp;<%=rc_bean2.getM_tel()%></td>
                </tr>
            </table>
        </td>
    </tr>

    <%}else{%>
    <%}%>
    <%if(rent_st.equals("2")){
		//�����������
		Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());%>
    <tr><td class=h></td></tr>
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
                    <td class=title width=11%>��������</td>
                    <td width=22%>&nbsp;<%=serv.get("OFF_NM")%></td>
                    <td class=title width=11%>����������ȣ</td>
                    <td width=22%>&nbsp;<%=serv.get("CAR_NO")%></td>
                    <td class=title width=11%>����</td>
                    <td width=23%>&nbsp;<%=serv.get("CAR_NM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("3")){
		//��������
		Hashtable accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id());%>
    <tr><td class=h></td></tr>
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
                    <td class=title width=11%> ��������</td>
                    <td width=22%>&nbsp;<%=accid.get("OFF_NM")%></td>
                    <td class=title width=11%>����������ȣ</td>
                    <td width=22%>&nbsp;<%=accid.get("CAR_NO")%></td>
                    <td class=title width=11%>����</td>
                    <td width=23%>&nbsp;<%=accid.get("CAR_NM")%></td>
                </tr>
                <tr> 
                    <td class=title> ������ȣ</td>
                    <td>&nbsp;<%=accid.get("P_NUM")%></td>
                    <td class=title>�����ں����</td>
                    <td>&nbsp;<%=accid.get("G_INS")%></td>
                    <td class=title>�����</td>
                    <td>&nbsp;<%=accid.get("G_INS_NM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("9")){
		//�����������
		RentInsBean ri_bean = rs_db.getRentInsCase(rc_bean.getSub_c_id());%>
    <tr><td class=h></td></tr>
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
                    <td class=title> ������ȣ</td>
                    <td>&nbsp;<%=ri_bean.getIns_num()%></td>
                    <td class=title>�����</td>
                    <td colspan="5"> 
                      &nbsp;<select name='ins_com_id' disabled>
                        <%if(ic_size > 0){
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>" <%if(ri_bean.getIns_com_id().equals(ic.getIns_com_id()))%>selected<%%>><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%> �����</td>
                    <td width=15%>&nbsp;<%=ri_bean.getIns_nm()%></td>
                    <td class=title width=10%>����ó��</td>
                    <td width=15%>&nbsp;<%=ri_bean.getIns_tel()%></td>
                    <td class=title width=10%>����ó��</td>
                    <td width=15%>&nbsp;<%=ri_bean.getIns_tel2()%></td>
                    <td class=title width=10%>�ѽ�</td>
                    <td width=15%>&nbsp;<%=ri_bean.getIns_fax()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("6")){
		//������������
		Hashtable serv = rs_db.getInfoServ(c_id, rc_bean.getServ_id());%>
    <tr><td class=h></td></tr>
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
                    <td class=title width=11%>��������</td>
                    <td width=39%>&nbsp;<%=serv.get("OFF_NM")%></td>
                    <td class=title width=10%> ��������</td>
                    <td width=40%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(serv.get("SERV_DT")))%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("7")){
		//������������
		Hashtable maint = rs_db.getInfoMaint(c_id, rc_bean.getMaint_id());%>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>�˻���ȿ�Ⱓ</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("8")){
		//����������
		Hashtable accid = rs_db.getInfoAccid(c_id, rc_bean.getAccid_id());%>
    <tr><td class=h></td></tr>
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
                    <td class=title width=11%>��������</td>
                    <td width=22%>&nbsp;<%=accid.get("OFF_NM")%></td>
                    <td class=title width=11%>�������</td>
                    <td width=22%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(accid.get("ACCID_DT")))%></td>
                    <td class=title width=11%>�����</td>
                    <td width=23%>&nbsp;<%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%></td>
                </tr>
                <tr> 
                    <td class=title>�����</td>
                    <td colspan="5">&nbsp;<%=accid.get("ACCID_CONT")%>&nbsp;<%=accid.get("ACCID_CONT2")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
	<tr><td class=h></td></tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
        <td align="right"><font color="#999999"> 
        <%if(!rc_bean.getReg_id().equals("")){%>
        <img src=/acar/images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(rc_bean.getReg_id(), "USER")%>&nbsp;&nbsp; 
        <img src=/acar/images/center/arrow_ccdri.gif align=absmiddle> : <%=AddUtil.ChangeDate2(rc_bean.getReg_dt())%> 
        <%}%>
        <%if(!rc_bean.getUpdate_id().equals("")){%>
        &nbsp;&nbsp;<img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : <%=c_db.getNameById(rc_bean.getUpdate_id(), "USER")%>&nbsp;&nbsp; 
        <img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> : <%=AddUtil.ChangeDate2(rc_bean.getUpdate_dt())%> 
        <%}%>
        </font></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=11%>����ȣ</td>
                    <td width=15%>&nbsp;<%=rc_bean.getRent_s_cd()%></td>
                    <td class=title width=10%>�������</td>
                    <td width=14%>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%></td>
                    <td class=title width=10%>������</td>
                    <td width=15%> 
                      &nbsp;<select name='s_brch_id' disabled>
                        <option value=''>��ü</option>
                        <%if(brch_size > 0){
        					for (int i = 0 ; i < brch_size ; i++){
        						Hashtable branch = (Hashtable)branches.elementAt(i);%>
                        <option value='<%= branch.get("BR_ID") %>' <%if(rc_bean.getBrch_id().equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td width=10% class=title><%if(rent_st.equals("12")) {%>���ʿ����� <%} else {%>����� <%}%></td>
                    <td width=15%> 
                      &nbsp;<%=c_db.getNameById(rc_bean.getBus_id(),"USER")%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�̿�Ⱓ</td>
                    <td colspan="5">&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRent_start_dt_d())%> 
                      <select name="rent_start_dt_h" onChange="getRentTime(); setDtHS(this);" disabled>
                        <%for(int i=0; i<25; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRent_start_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="rent_start_dt_s" onChange="getRentTime(); setDtHS(this);" disabled>
                        <%for(int i=0; i<60; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRent_start_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      ~ <%=AddUtil.ChangeDate2(rc_bean.getRent_end_dt_d())%> 
                      <select name="rent_end_dt_h" onChange="getRentTime(); setDtHS(this);" disabled>
                        <%for(int i=0; i<25; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRent_end_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="rent_end_dt_s" onChange="getRentTime(); setDtHS(this);" disabled>
                        <%for(int i=0; i<60; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRent_end_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      ( <%=rc_bean.getRent_hour()%>�ð� <%=rc_bean.getRent_days()%>�� <%=rc_bean.getRent_months()%>���� 
                      ) </td>
                    <td width=10% class=title>���������</td>
                    <td width=15%> 
                      &nbsp;<%=c_db.getNameById(rc_bean.getMng_id(),"USER")%>
                    </td>                      
                </tr>
    		  <%
    			if(ext_size > 0){
    				for(int i = 0 ; i < ext_size ; i++){
    					Hashtable ext = (Hashtable)exts.elementAt(i);%>		  
                <tr> 
                    <td class=title>���� [<%=i+1%>]</td>
                    <td colspan="7">&nbsp; 
                        ������� : <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_DT")))%> &nbsp;&nbsp;
                        | �뿩�Ⱓ : <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_END_DT")))%> &nbsp;&nbsp;                    	
                        (<%=ext.get("RENT_MONTHS")%>����<%=ext.get("RENT_DAYS")%>��)                   	
                    </td>
                </tr>
    		  <%		
    		  		}
    		  	}%> 	                
                <tr> 
                    <td class=title>��Ÿ Ư�̻���</td>
                    <td colspan="7">&nbsp;<%=rc_bean.getEtc()%></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����/����</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=11%>���������Ͻ�</td>
                    <td width=39%>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getDeli_plan_dt_d())%> 
                      <select name="deli_plan_dt_h" disabled>
                        <%for(int i=0; i<25; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_plan_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="deli_plan_dt_s" disabled>
                        <%for(int i=0; i<60; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_plan_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title width=10%>������ġ</td>
                    <td width=40%>&nbsp;<%=rc_bean.getDeli_loc()%></td>
                </tr>
                <%//if(!rent_st.equals("11")){%>
                <tr> 
                    <td class=title>�����Ͻ�</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%> 
                      <select name="deli_dt_h" disabled>
                        <option value="">����</option>
                        <%for(int i=0; i<25; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="deli_dt_s" disabled>
                        <option value="">����</option>
                        <%for(int i=0; i<60; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title>���������</td>
                    <td> 
                      &nbsp;<select name='deli_mng_id' disabled>
                        <option value="">������</option>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>'  <%if(rc_bean.getDeli_mng_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>
              <%//}else{%>
    		  <!--
              <input type='hidden' name="deli_dt">
              <input type='hidden' name="deli_dt_h">
              <input type='hidden' name="deli_dt_s">
              <input type='hidden' name="deli_mng_id">-->
              <%//}%>
                <tr> 
                    <td class=title>���������Ͻ�</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%> 
                      <select name="ret_plan_dt_h" disabled>
                        <%for(int i=0; i<25; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="ret_plan_dt_s" disabled>
                        <%for(int i=0; i<60; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title>������ġ</td>
                    <td>&nbsp;<%=rc_bean.getRet_loc()%></td>
                </tr>
                <tr> 
                    <td class=title>�����Ͻ�</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%> 
                      <select name="ret_dt_h" disabled>
                        <option value="">����</option>
                        <%for(int i=0; i<25; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="ret_dt_s" disabled>
                        <option value="">����</option>
                        <%for(int i=0; i<60; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title>���������</td>
                    <td> 
                      &nbsp;<select name='ret_mng_id' disabled>
                        <option value="">������</option>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>'  <%if(rc_bean.getRet_mng_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>		  
            </table>
        </td>
    </tr>
    <tr align="right"> 
        <td colspan="2"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
</body>
</html>
