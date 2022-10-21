<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.client.*, acar.common.*, acar.cus_reg.*, acar.car_service.*, acar.serv_off.*, acar.pay_mng.*, acar.doc_settle.*, acar.user_mng.*"%>
<jsp:useBean id="cinfo_bean" class="acar.car_service.ContInfoBean" scope="page"/>
<jsp:useBean id="so_bean" class="acar.serv_off.ServOffBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String accid_st = request.getParameter("accid_st")==null?"":request.getParameter("accid_st");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String go_url = request.getParameter("go_url")==null?"N":request.getParameter("go_url");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int result=0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CusReg_Database cr_db = CusReg_Database.getInstance();
	CarServDatabase csd = CarServDatabase.getInstance();
	ServOffDatabase sod = ServOffDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	
	
	
	//�α�������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	String dept_id = login.getDept_id(user_id);
	
	if(rent_mng_id.equals("")||rent_l_cd.equals("")){
		Hashtable ht = c_db.getRent_id(car_mng_id);
		rent_mng_id = (String)ht.get("RENT_MNG_ID")==null?"":(String)ht.get("RENT_MNG_ID");
		rent_l_cd 	= (String)ht.get("RENT_L_CD")==null?"":(String)ht.get("RENT_L_CD");
	}
	
	
	ServInfoBean siBn = cr_db.getServInfo(car_mng_id, serv_id);
			
	if(rent_mng_id.equals("")||rent_l_cd.equals("")){
		rent_mng_id = siBn.getRent_mng_id();
		rent_l_cd 	= siBn.getRent_l_cd();
	}
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	Serv_ItemBean[] siBns = cr_db.getServ_item(car_mng_id, serv_id, "asc");
	
	cinfo_bean = csd.getContInfo(rent_mng_id, rent_l_cd, car_mng_id);
	
	//��ݿ���
	Hashtable serv_pay = ps_db.getPayServ(car_mng_id, serv_id);
	String serv_reg_st = (String)serv_pay.get("SERV_REG_ST")==null?"":(String)serv_pay.get("SERV_REG_ST");
	
	//ī�����
	Hashtable serv_card = ps_db.getCardServ(car_mng_id, serv_id);
	String card_buy_dt = (String)serv_card.get("BUY_DT")==null?"":(String)serv_card.get("BUY_DT");
	
	//������,������ ����Ʈ����
	if(siBn.getChecker().equals(""))	siBn.setChecker(user_id);
	if(siBn.getSpdchk_dt().equals("")&& AddUtil.parseInt(siBn.getServ_dt())>20040801)	siBn.setSpdchk_dt(Util.getDate());
	
	//��ȸ����-speedcheck
	SpdchkBean spdchk = new SpdchkBean();
	CarInfoBean ci_bean = new CarInfoBean();
	if(rent_l_cd.equals("")){
		ci_bean = cr_db.getCarInfo(car_mng_id);
	}else{
		ci_bean = cr_db.getCarInfo(car_mng_id, rent_l_cd);
	}
	
	SpdchkBean[] spdchks = cr_db.getSpdchk();
	
	String[] seq = null;
	int	x=0,y=0,z = 0;
	if(!siBn.getSpd_chk().equals("")){
		Vector vt = new Vector();
		StringTokenizer st = new StringTokenizer(siBn.getSpd_chk(),"/");
		int k = 0;
		seq = new String[st.countTokens()];
		while(st.hasMoreTokens()){
			seq[k] = st.nextToken();
			if(seq[k].substring(0,1).equals("1")){
				x++;
			}else if(seq[k].substring(0,1).equals("2")){
				y++;
			}else if(seq[k].substring(0,1).equals("3")){
				z++;
			}
			k++;
		}
	}
	
	float dc_rate = 0f;

	
	if(siBn.getOff_id().equals("")){
		if(user_id.equals("000047")){		//����������
			so_bean = sod.getServOff("000620");
		}else if(user_id.equals("000081")){	//����ī��ũ
			so_bean = sod.getServOff("001960");
		}else if(user_id.equals("000106")){	//�ΰ��ڵ�������
			so_bean = sod.getServOff("002105");
		}else if(user_id.equals("000110")){	//��������
			so_bean = sod.getServOff("001816");
		}else if(user_id.equals("000112")){	//����ī��ũ����
			so_bean = sod.getServOff("002734");
		}else if(user_id.equals("000143")){	//���������ڵ����������
			so_bean = sod.getServOff("000286");
		}
		siBn.setOff_id(so_bean.getOff_id());
		siBn.setOff_nm(so_bean.getOff_nm());
	}
	
	Serv_ItemBean[] siIBns = cr_db.getServ_item(car_mng_id, serv_id, "asc");
	
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettleCommi("41", car_mng_id+""+serv_id);
	String doc_no = doc.getDoc_no();
	
	double amt_sum = 0;
	double labor_sum = 0;
	
	//����, �ΰ��� ��� :������ ���ӿ� ���� (�������翡�� ������ �������� �Ѵ� 20090604)
	double r_amt_sum = 0;
	double r_labor_sum = 0;
%>

<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name="view_display" value="">
<input type='hidden' name="auth_rw" value="">
<input type='hidden' name='car_mng_id' 	value='<%= car_mng_id %>'>
<input type='hidden' name='serv_id' 	value='<%= serv_id %>'>
<input type='hidden' name='off_id' 		value='<%= siBn.getOff_id() %>'>
<input type='hidden' name='cmd' 		value='<%= cmd %>'>
<input type='hidden' name='accid_id' 	value='<%= siBn.getAccid_id() %>'>
<input type='hidden' name='accid_st' 	value='<%= accid_st%>'>
<input type='hidden' name='rent_mng_id' value='<%= rent_mng_id %>'>
<input type='hidden' name='rent_l_cd' 	value='<%= rent_l_cd %>'>
<input type='hidden' name='jung_st' 	value='<%= siBn.getJung_st() %>'>
<input type='hidden' name='car_no' 		value='<%= ci_bean.getCar_no() %>'>
<input type='hidden' name='card_tot_amt' value= '<%= siBn.getTot_amt() %>'>
<input type='hidden' name='from_page'	value='<%=from_page%>'>   
<input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
<input type='hidden' name="doc_bit" 	value="">          
<table width="800" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > <span class=style5>�ڵ���������</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr bgcolor="#FFFFFF"> 
                <td class='title' width=10%>������ȣ</td>
                <td class='left' width=15% align="left">&nbsp;&nbsp;<%= ci_bean.getCar_no() %></td>
                <td class='title' width=10%>����</td>
                <td class='left' width=40% align="left">&nbsp;&nbsp;<%= ci_bean.getCar_jnm() %> <%= ci_bean.getCar_nm() %></td>
                <td class='title' width=10%>���ʵ����</td>
                <td class='left' width=15% align="center"><%= AddUtil.ChangeDate2(ci_bean.getInit_reg_dt()) %></td>
                </tr>
                <tr>
                  <td class='title'>��ȣ</td>
                  <td colspan='5'>&nbsp;&nbsp;<%= client.getFirm_nm() %></td>
                </tr>                
            </table>
	    </td>
    </tr>
    <tr>
        <td></td>
    </tr>	
    <tr> 
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ�������</span></td>
                    <td align="right"><font color="#666666">&nbsp;</font></td>
                </tr>	
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>	  
                <tr> 
                    <td class=line colspan="2"> 
                        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                            <tr> 
                                <td class='title' width=10%>������</td>
                                <td class='left' width=15%>&nbsp;
                                	<%=c_db.getNameById(siBn.getChecker(),"USER")%> 
                               </td>
                                <td class='title' width=10%>������</td>
                                <td width=15%>&nbsp;
            				    <% if(siBn.getChecker_st().equals("1")) out.print("������"); %>
            					  <% if(siBn.getChecker_st().equals("2")) out.print("��������"); %>
            					  <% if(siBn.getChecker_st().equals("4")) out.print("��ȸ������"); %>
            					  <% if(siBn.getChecker_st().equals("3")) out.print("��"); %>
                                </td>
                                <td class='title' width=10%>��ȸ������ </td>
                                <td class='left' width=15%>&nbsp; <%= AddUtil.ChangeDate2(siBn.getSpdchk_dt()) %></td>
                                <td class='title' colspan="2">��ȸ���˻��� </td>
                            </tr>
                            <tr> 
                                <td class='title'>����Ÿ�</td>
                                <td colspan="3" class='left'>&nbsp; <%= AddUtil.parseDecimal(siBn.getTot_dist()) %> km </td>
                                <td class='title'>���˿�����</td>
                                <td class='left'>&nbsp; <%= AddUtil.ChangeDate2(siBn.getNext_serv_dt()) %></td>
                                <td width=10% class='title'>��ȣ</td>
                                <td width=15% align="center" class='left'><input type="text" name="x" class="whitenum" value="<%= x %>" size="2"> ��</td>
                            </tr>
                            <tr> 
                                <td class='title' rowspan="3">��ġ</td>
                                <td class='left' colspan="5" rowspan="3" width=65%>&nbsp; <textarea name="rep_cont" cols="70" rows="3" style='IME-MODE: active'><%= siBn.getRep_cont() %></textarea> 
                                </td>
                                <td class='title'>����</td>
                                <td class='left' align="center"><input type="text" name="y" class="whitenum" value="<%= y %>" size="2"> ��</td>
                            </tr>
                            <tr> 
                                <td class='title'>�ҷ�</td>
                                <td class='left' align="center"><input type="text" name="z" class="whitenum" value="<%= z %>" size="2"> ��</td>
                            </tr>
                            <tr> 
                                <td class='title'>����з�</td>
                                <td class='left' align="center">&nbsp; 
                                	 <%		if(siBn.getServ_st().equals("1")){
                													out.print("��ȸ����");
                												}else if(siBn.getServ_st().equals("2")){
                													out.print("�Ϲݼ���");
                												}else if(siBn.getServ_st().equals("3")){
                													out.print("��������");
                												}else if(siBn.getServ_st().equals("4")){
                													out.print("����Ǳ�ȯ");
                												}else if(siBn.getServ_st().equals("7")){
                													out.print("�縮������");
                												}else if(siBn.getServ_st().equals("11")){
                													out.print("������������");
                												}else if(siBn.getServ_st().equals("12")){
                													out.print("����");
                												}else if(siBn.getServ_st().equals("13")){
                													out.print("����");
                												}
                										%>                                	
                				       </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="general" style="display:<% if ((siBn.getServ_st().equals("1") ) ||((!cmd.equals("4"))&&siBn.getServ_st().equals("")&&siBn.getOff_id().equals(""))&&!dept_id.equals("8888")){ %>none<% }else{ %>''<% } %>;"> 
                    <td colspan="2">
                        <table width="800" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td>
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td></td>
                                        </tr>
                                        <tr> 
                                            <td> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ�������</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td class=line2 colspan=2></td>
                                                    </tr>	  
                                                    <tr> 
                                                        <td class=line colspan="2"> 
                                                            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                                                                <tr> 
                                                                    <td class='title' width=10%>����</td>
                                                                    <td class='left' width=15%>&nbsp; 
                                                                        <% if(siBn.getServ_jc().equals("1")) out.print("����湮"); %>
                                                                        <% if(siBn.getServ_jc().equals("2")) out.print("����û"); %>
                                                                        <% if(siBn.getServ_jc().equals("9")) out.print("������"); %>
                                                                    </td>
                                                                    <td class='title' width=10%>��������</td>
                                                                    <td class='left' width=25%>&nbsp; <%= AddUtil.ChangeDate2(siBn.getServ_dt()) %></td>
                                                                    <td class='title' width=15%>�����ü</td>
                                                                    <td class='left' width=25%>&nbsp; <%= siBn.getOff_nm() %></td>
                                                                </tr>
                                                                <tr> 
                                                                    <td class='title'>�԰�����</td>
                                                                    <td class='left'>&nbsp; <%=c_db.getNameById(siBn.getIpgoza(),"USER")%> </td>
                                					
                                                                    <td class='title'>�԰�����</td>
                                                                    <td colspan="3" class='left'>&nbsp; <%if(!siBn.getIpgodt().equals("")){ %><%=AddUtil.ChangeDate2(siBn.getIpgodt().substring(0,8))%>&nbsp;<%=AddUtil.ChangeDate2(siBn.getIpgodt().substring(8,10))%>��<%=AddUtil.ChangeDate2(siBn.getIpgodt().substring(10,12))%>��<%}%></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height="20" class='title'>�������</td>
                                                                    <td class='left'>&nbsp; <%=c_db.getNameById(siBn.getChulgoza(),"USER")%></td>
                                                                    <td class='title'>�������</td>
                                                                    <td colspan="3" class='left'>&nbsp; <%if(!siBn.getChulgodt().equals("")){ %><%=AddUtil.ChangeDate2(siBn.getChulgodt().substring(0,8))%>&nbsp;<%=AddUtil.ChangeDate2(siBn.getChulgodt().substring(8,10))%>��<%=AddUtil.ChangeDate2(siBn.getChulgodt().substring(10,12))%>��<%}%></td>
                                                                </tr>
                                                                <tr> 
                                                                    <td height="20" class='title'>��������</td>
                                                                    <td class='left' colspan="5">&nbsp;������: 
                                                                      <input type="text" name="cust_act_dt" size="12" class=text value="<%= AddUtil.ChangeDate2(siBn.getCust_act_dt()) %>" onBlur='javascript:this.value=ChangeDate(this.value)'>&nbsp;
                                                                      �̸�: 
                                                                      <input type="text" name="cust_nm" size="10" class=text value="<%= siBn.getCust_nm() %>">&nbsp;
                                                                      ����ó: 
                                                                      <input type="text" name="cust_tel" size="15" class=text value="<%= siBn.getCust_tel() %>">&nbsp;
                                                                      ����: 
                                                                      <input type="text" name="cust_rel" size="30" class=text value="<%= siBn.getCust_rel() %>"> 
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                    </tr>
                                                    <tr> 
                                                        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����/����</span></td>
                                                        <td align="right">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                        <td colspan="2">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="line">
                                                                        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                                                                            <tr> 
                                                                                <td class='title' width=4%>����</td>
                                                                                <td class='title' width=9%>����</td>
                                                                                <td class='title' width=36%>�۾��׸� �� ��ȯ��ǰ</td>
                                                                                <td class='title' width=12%>�۾�</td>
                                    										    <td class='title' width=13%>��ǰ�ڵ�</td>																				
                                                                                <td class='title' width=13%>��ǰ����</td>
                                                                                <td class='title' width=13%>����</td>
                                                                            </tr>
																			<%	if(siBns.length >0){
        																			for(int i=0; i<siBns.length; i++){
        																				Serv_ItemBean siBn2 = siBns[i];
																						
        																				amt_sum += siBn2.getAmt();
        																				labor_sum += siBn2.getLabor(); 
        																				r_labor_sum += siBn2.getLabor(); 
        																				if ( siBn2.getWk_st().equals("����")) {
        																					r_labor_sum += siBn2.getAmt();
        																				}
        																				else {
        																					r_amt_sum += siBn2.getAmt();
        																				}
																						
        					 	 %>
                                                                            <tr> 
                                                                                <td width=4% align="center"><%= i+1 %></td>
                                                                                <td width=9% align="center">&nbsp;<%= siBn2.getItem_st() %> </td>
                                                                                <td width=36% align="left">&nbsp;&nbsp;<%= siBn2.getItem() %></td>
                                                                                <td width=12% align="center">&nbsp;<%= siBn2.getWk_st() %> </td>
            	                                                                <td width=13% align="left">&nbsp;&nbsp;<%= siBn2.getItem_cd() %></td>							  
                                                                                <td width=13% align="right"><%= AddUtil.parseDecimal(siBn2.getAmt()) %>��&nbsp;</td>
                                                                                <td width=13% align="right"><%= AddUtil.parseDecimal(siBn2.getLabor()) %>��&nbsp;</td>
                                                                            </tr>
                                                                            <%		}
            				                                                	} %>	
                                                                            <tr> 
                                                                                <td colspan="5" class='title' style='text-align:right'>�� ��&nbsp;&nbsp; 
                                                                                <%= AddUtil.parseDecimal(amt_sum+labor_sum) %>��&nbsp;</td>
                                                                                <td class='title' style='text-align:right'><%= AddUtil.parseDecimal(amt_sum) %>��&nbsp;</td>
                                                                                <td class='title' style='text-align:right'><%= AddUtil.parseDecimal(labor_sum) %>��&nbsp;</td>
                                                                            </tr>																											 
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
													
                                                    <tr> 
                                                        <td colspan="2"><iframe src="item_serv_in_s.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>" name="item_serv_in" width="100%" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
                                                    </tr>
													
                                                    <tr> 
                                                        <td colspan="2">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                        <td colspan="2" class=line2></td>
                                                    </tr>
                                                    <tr> 
                                                        <td colspan="2" class="line">
                                                            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                                                      	        <tr> 
                                                                    <td class='title' width=9%>����</td>
                                                                    <td width=15% align=right><input type="text" name="r_labor" size="8" value='<%= AddUtil.parseDecimal(labor_sum) %>' class=whitenum readonly="true" >
                                                                      ��&nbsp;</td>
                                                                    <td class='title' width=9%>��ǰ</td>
                                                                    <td align=right width=15%>&nbsp; <input type="text" name="r_amt" size="8" value='<%= AddUtil.parseDecimal(amt_sum) %>' class=whitenum readonly="true"  >
                                                                      ��&nbsp;</td>
                                                                    <td class='title' width=9%>��ǰDC</td>
                                                                    <td align=right width=15%>&nbsp; <input type="text" name="r_dc" size="9" class=whitenum  value="<%= AddUtil.parseDecimal(siBn.getR_dc()) %>" >
                                                                      %&nbsp;</td>
                                                                    <td class='title' width=9%>��ǰ(����)</td>
                                								    <td width=19%>&nbsp; <input type="text" name="r_j_amt" size="9" class=whitenum value="<%= AddUtil.parseDecimal(siBn.getR_j_amt()) %>" >
                                								    ��</td>
                                                                </tr>	
                                                                <tr> 
                                                                    <td class='title'>���ް�</td>
                                                                    <td align=right>&nbsp; <input type="text" name="sup_amt" size="8" class=whitenum  value="<%= AddUtil.parseDecimal(siBn.getSup_amt()) %>">
                                                                      ��&nbsp;</td>
                                                                    <td class='title'>�ΰ���</td>
                                                                    <td align=right>&nbsp; <input type="text" name="add_amt" size="8" class=whitenum value="<%= AddUtil.parseDecimal(siBn.getAdd_amt()) %>" >
                                                                      ��&nbsp;</td>
                                                                    <td class='title'>����ݾ�</td>
                                                                    <td align=right>&nbsp; <input type="text" name="rep_amt" size="9" class=whitenum readonly="true" value="<%= AddUtil.parseDecimal(siBn.getRep_amt()) %>">
                                                                      ��&nbsp;</td>                                                                        
                                                                    <td class='title'>-</td>
                                									                     <input type="hidden" name="item_sum" value="0">
                                                                    <td>&nbsp;</td>           									
                                                                  
                                                                </tr>
                                                                <tr> 
                                                                    <td class='title'>DC��</td>
                                                                    <td align=right>&nbsp; <input type="text" name="dc_rate" size="8" class=whitenum  value="<%= AddUtil.parseFloatCipher2(dc_rate,2) %>" >
                                                                      %&nbsp;</td>
                                                                    <td class='title'>DC</td>
                                                                    <td align=right>&nbsp; <input type="text" name="dc" size="8" class=whitenum value="<%= AddUtil.parseDecimal(siBn.getDc()) %>" >
                                                                      ��&nbsp;</td>
                                                                    <td class='title'>���ޱݾ�</td>
                                                                    <td align=right>&nbsp; <input type="text" name="tot_amt" size="9" class=whitenum value="<%= AddUtil.parseDecimal(siBn.getTot_amt()) %>">
                                                                      ��&nbsp;</td>
                                                                    <td class='title'>������</td>
                                                                    <td>&nbsp;<input name="set_dt" type="text" class="whitetext" value="<%= AddUtil.ChangeDate2(siBn.getSet_dt()) %>" size="11">
                                                                      </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>	
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>	    
	<%if(!card_buy_dt.equals("")){%>						
    <tr> 
      <td colspan="2">&nbsp;�� ����ī��� ����Ǿ����ϴ�. (<%=serv_card.get("CARDNO")%> <%=serv_card.get("BUY_DT")%>)</td>
    </tr>			
	<%}%>															
	<%if(serv_reg_st.equals("Y")){%>						
    <tr> 
      <td colspan="2">&nbsp;�� ��ݿ��忡�� ��ĵ�ϵǾ����ϴ�.(<%=serv_pay.get("REG_NM")%> <%=serv_pay.get("REG_DT")%>)</td>
    </tr>			
	<%}%>																															
	<%if(serv_reg_st.equals("S")){%>						
    <tr> 
      <td colspan="2">&nbsp;�� ��ݿ��忡 ��ݵ�ϵǾ����ϴ�.(<%=serv_pay.get("REG_NM")%> <%=serv_pay.get("REG_DT")%>)</td>
    </tr>			
	<%}%>													
	<%if(serv_reg_st.equals("Y") || serv_reg_st.equals("S")){%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr bgcolor="#FFFFFF"> 
                <td class='title' width=10%>�����ȣ</td>
                <td width=40%>&nbsp;&nbsp;<%=serv_pay.get("REQSEQ")%></td>
                <td class='title' width=10%>�������</td>
                <td width=40%>&nbsp;&nbsp;<%=serv_pay.get("P_PAY_DT")%></td>
              </tr>
			  <%
				String content_code1 = "PAY";
				String content_seq1  = (String)serv_pay.get("REQSEQ");

				Vector attach_vt2 = c_db.getAcarAttachFileList(content_code1, content_seq1, 0);		
				int attach_vt2_size = attach_vt2.size();
				
			//	out.println(content_code1);		
			//	out.println(content_seq1);		
			//	out.println(attach_vt2_size);		
			  %>
			  <%if(attach_vt2_size > 0){%>
			    <%	for (int k = 0 ; k < attach_vt2_size ; k++){
    					Hashtable ht2 = (Hashtable)attach_vt2.elementAt(k);%>
				<tr bgcolor="#FFFFFF"> 
					<td class='title'>��������<%=k+1%></td>						
    				<td colspan='3'>	&nbsp;<a href="javascript:openPopP('<%=ht2.get("FILE_TYPE")%>','<%=ht2.get("SEQ")%>');" title='����' ><%=ht2.get("FILE_NAME")%></a>
    					&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht2.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
					</td>
				</tr>
   			    <%	}%>		
			<%	}%>	
            </table>
	    </td>
    </tr>	
	<%}%>
	
	<%if(siBn.getTot_amt() > 0 || siBn.getTot_amt() < 0 || siBn.getServ_st().equals("4") || siBn.getServ_st().equals("3")){
	
	
			//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
		
	
			String content_code = "SERVICE";
			String content_seq  = siBn.getCar_mng_id()+""+siBn.getServ_id();

			Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
			int attach_vt_size = attach_vt.size();		
	
	%>
	
	
	<tr>
	    <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ ��ĵ</span></td>
	</tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr bgcolor="#FFFFFF"> 
                    <td class='title' width=10%>������ȣ</td>
                    <td width=15% align="left">&nbsp;<%= siBn.getEstimate_num() %></td>
                    <td class='title' width=10%>������</td>
                    <td>&nbsp;
			<%if(attach_vt_size > 0){%>
			    <%	for (int j = 0 ; j < attach_vt_size ; j++){
    					Hashtable ht = (Hashtable)attach_vt.elementAt(j);%>
    					&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
    					<%if(j+1 < attach_vt_size){%><br><%}%>
    			    <%	}%>		
			<%}%>
		    </td>
                </tr>
            </table>
	    </td>
    </tr>	
    <%}%>    
</table>
</form>
</body>
</html>
<script language='javascript'>
<!-- 

//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
