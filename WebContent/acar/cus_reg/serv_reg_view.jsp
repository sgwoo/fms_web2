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
	
	
	
	
	//로그인정보
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
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	Serv_ItemBean[] siBns = cr_db.getServ_item(car_mng_id, serv_id, "asc");
	
	cinfo_bean = csd.getContInfo(rent_mng_id, rent_l_cd, car_mng_id);
	
	//출금원장
	Hashtable serv_pay = ps_db.getPayServ(car_mng_id, serv_id);
	String serv_reg_st = (String)serv_pay.get("SERV_REG_ST")==null?"":(String)serv_pay.get("SERV_REG_ST");
	
	//카드결재
	Hashtable serv_card = ps_db.getCardServ(car_mng_id, serv_id);
	String card_buy_dt = (String)serv_card.get("BUY_DT")==null?"":(String)serv_card.get("BUY_DT");
	
	//점검자,점검일 디폴트세팅
	if(siBn.getChecker().equals(""))	siBn.setChecker(user_id);
	if(siBn.getSpdchk_dt().equals("")&& AddUtil.parseInt(siBn.getServ_dt())>20040801)	siBn.setSpdchk_dt(Util.getDate());
	
	//순회점검-speedcheck
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
		if(user_id.equals("000047")){		//명진공업사
			so_bean = sod.getServOff("000620");
		}else if(user_id.equals("000081")){	//동부카독크
			so_bean = sod.getServOff("001960");
		}else if(user_id.equals("000106")){	//부경자동차정비
			so_bean = sod.getServOff("002105");
		}else if(user_id.equals("000110")){	//삼일정비
			so_bean = sod.getServOff("001816");
		}else if(user_id.equals("000112")){	//현대카독크대전
			so_bean = sod.getServOff("002734");
		}else if(user_id.equals("000143")){	//정일현대자동차정비공업
			so_bean = sod.getServOff("000286");
		}
		siBn.setOff_id(so_bean.getOff_id());
		siBn.setOff_nm(so_bean.getOff_nm());
	}
	
	Serv_ItemBean[] siIBns = cr_db.getServ_item(car_mng_id, serv_id, "asc");
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettleCommi("41", car_mng_id+""+serv_id);
	String doc_no = doc.getDoc_no();
	
	double amt_sum = 0;
	double labor_sum = 0;
	
	//명진, 부경인 경우 :도장을 공임에 포함 (모든공업사에서 도장은 공임으로 한다 20090604)
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > <span class=style5>자동차정비등록</span></span></td>
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
                <td class='title' width=10%>차량번호</td>
                <td class='left' width=15% align="left">&nbsp;&nbsp;<%= ci_bean.getCar_no() %></td>
                <td class='title' width=10%>차명</td>
                <td class='left' width=40% align="left">&nbsp;&nbsp;<%= ci_bean.getCar_jnm() %> <%= ci_bean.getCar_nm() %></td>
                <td class='title' width=10%>최초등록일</td>
                <td class='left' width=15% align="center"><%= AddUtil.ChangeDate2(ci_bean.getInit_reg_dt()) %></td>
                </tr>
                <tr>
                  <td class='title'>상호</td>
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
                    <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차점검</span></td>
                    <td align="right"><font color="#666666">&nbsp;</font></td>
                </tr>	
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>	  
                <tr> 
                    <td class=line colspan="2"> 
                        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                            <tr> 
                                <td class='title' width=10%>점검자</td>
                                <td class='left' width=15%>&nbsp;
                                	<%=c_db.getNameById(siBn.getChecker(),"USER")%> 
                               </td>
                                <td class='title' width=10%>시행자</td>
                                <td width=15%>&nbsp;
            				    <% if(siBn.getChecker_st().equals("1")) out.print("관리자"); %>
            					  <% if(siBn.getChecker_st().equals("2")) out.print("업무협조"); %>
            					  <% if(siBn.getChecker_st().equals("4")) out.print("순회점검팀"); %>
            					  <% if(siBn.getChecker_st().equals("3")) out.print("고객"); %>
                                </td>
                                <td class='title' width=10%>순회점검일 </td>
                                <td class='left' width=15%>&nbsp; <%= AddUtil.ChangeDate2(siBn.getSpdchk_dt()) %></td>
                                <td class='title' colspan="2">순회점검상태 </td>
                            </tr>
                            <tr> 
                                <td class='title'>주행거리</td>
                                <td colspan="3" class='left'>&nbsp; <%= AddUtil.parseDecimal(siBn.getTot_dist()) %> km </td>
                                <td class='title'>점검예정일</td>
                                <td class='left'>&nbsp; <%= AddUtil.ChangeDate2(siBn.getNext_serv_dt()) %></td>
                                <td width=10% class='title'>양호</td>
                                <td width=15% align="center" class='left'><input type="text" name="x" class="whitenum" value="<%= x %>" size="2"> 건</td>
                            </tr>
                            <tr> 
                                <td class='title' rowspan="3">조치</td>
                                <td class='left' colspan="5" rowspan="3" width=65%>&nbsp; <textarea name="rep_cont" cols="70" rows="3" style='IME-MODE: active'><%= siBn.getRep_cont() %></textarea> 
                                </td>
                                <td class='title'>보통</td>
                                <td class='left' align="center"><input type="text" name="y" class="whitenum" value="<%= y %>" size="2"> 건</td>
                            </tr>
                            <tr> 
                                <td class='title'>불량</td>
                                <td class='left' align="center"><input type="text" name="z" class="whitenum" value="<%= z %>" size="2"> 건</td>
                            </tr>
                            <tr> 
                                <td class='title'>정비분류</td>
                                <td class='left' align="center">&nbsp; 
                                	 <%		if(siBn.getServ_st().equals("1")){
                													out.print("순회점검");
                												}else if(siBn.getServ_st().equals("2")){
                													out.print("일반수리");
                												}else if(siBn.getServ_st().equals("3")){
                													out.print("보증수리");
                												}else if(siBn.getServ_st().equals("4")){
                													out.print("계기판교환");
                												}else if(siBn.getServ_st().equals("7")){
                													out.print("재리스정비");
                												}else if(siBn.getServ_st().equals("11")){
                													out.print("신차영업관련");
                												}else if(siBn.getServ_st().equals("12")){
                													out.print("해지");
                												}else if(siBn.getServ_st().equals("13")){
                													out.print("자차");
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
                                                        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차정비</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td class=line2 colspan=2></td>
                                                    </tr>	  
                                                    <tr> 
                                                        <td class=line colspan="2"> 
                                                            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                                                                <tr> 
                                                                    <td class='title' width=10%>구분</td>
                                                                    <td class='left' width=15%>&nbsp; 
                                                                        <% if(siBn.getServ_jc().equals("1")) out.print("정기방문"); %>
                                                                        <% if(siBn.getServ_jc().equals("2")) out.print("고객요청"); %>
                                                                        <% if(siBn.getServ_jc().equals("9")) out.print("고객정비"); %>
                                                                    </td>
                                                                    <td class='title' width=10%>정비일자</td>
                                                                    <td class='left' width=25%>&nbsp; <%= AddUtil.ChangeDate2(siBn.getServ_dt()) %></td>
                                                                    <td class='title' width=15%>정비업체</td>
                                                                    <td class='left' width=25%>&nbsp; <%= siBn.getOff_nm() %></td>
                                                                </tr>
                                                                <tr> 
                                                                    <td class='title'>입고담당자</td>
                                                                    <td class='left'>&nbsp; <%=c_db.getNameById(siBn.getIpgoza(),"USER")%> </td>
                                					
                                                                    <td class='title'>입고일자</td>
                                                                    <td colspan="3" class='left'>&nbsp; <%if(!siBn.getIpgodt().equals("")){ %><%=AddUtil.ChangeDate2(siBn.getIpgodt().substring(0,8))%>&nbsp;<%=AddUtil.ChangeDate2(siBn.getIpgodt().substring(8,10))%>시<%=AddUtil.ChangeDate2(siBn.getIpgodt().substring(10,12))%>분<%}%></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height="20" class='title'>출고담당자</td>
                                                                    <td class='left'>&nbsp; <%=c_db.getNameById(siBn.getChulgoza(),"USER")%></td>
                                                                    <td class='title'>출고일자</td>
                                                                    <td colspan="3" class='left'>&nbsp; <%if(!siBn.getChulgodt().equals("")){ %><%=AddUtil.ChangeDate2(siBn.getChulgodt().substring(0,8))%>&nbsp;<%=AddUtil.ChangeDate2(siBn.getChulgodt().substring(8,10))%>시<%=AddUtil.ChangeDate2(siBn.getChulgodt().substring(10,12))%>분<%}%></td>
                                                                </tr>
                                                                <tr> 
                                                                    <td height="20" class='title'>고객시행자</td>
                                                                    <td class='left' colspan="5">&nbsp;접수일: 
                                                                      <input type="text" name="cust_act_dt" size="12" class=text value="<%= AddUtil.ChangeDate2(siBn.getCust_act_dt()) %>" onBlur='javascript:this.value=ChangeDate(this.value)'>&nbsp;
                                                                      이름: 
                                                                      <input type="text" name="cust_nm" size="10" class=text value="<%= siBn.getCust_nm() %>">&nbsp;
                                                                      연락처: 
                                                                      <input type="text" name="cust_tel" size="15" class=text value="<%= siBn.getCust_tel() %>">&nbsp;
                                                                      관계: 
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
                                                        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>정비/수리</span></td>
                                                        <td align="right">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                        <td colspan="2">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="line">
                                                                        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                                                                            <tr> 
                                                                                <td class='title' width=4%>연번</td>
                                                                                <td class='title' width=9%>구분</td>
                                                                                <td class='title' width=36%>작업항목 및 교환부품</td>
                                                                                <td class='title' width=12%>작업</td>
                                    										    <td class='title' width=13%>부품코드</td>																				
                                                                                <td class='title' width=13%>부품가격</td>
                                                                                <td class='title' width=13%>공임</td>
                                                                            </tr>
																			<%	if(siBns.length >0){
        																			for(int i=0; i<siBns.length; i++){
        																				Serv_ItemBean siBn2 = siBns[i];
																						
        																				amt_sum += siBn2.getAmt();
        																				labor_sum += siBn2.getLabor(); 
        																				r_labor_sum += siBn2.getLabor(); 
        																				if ( siBn2.getWk_st().equals("도장")) {
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
                                                                                <td width=13% align="right"><%= AddUtil.parseDecimal(siBn2.getAmt()) %>원&nbsp;</td>
                                                                                <td width=13% align="right"><%= AddUtil.parseDecimal(siBn2.getLabor()) %>원&nbsp;</td>
                                                                            </tr>
                                                                            <%		}
            				                                                	} %>	
                                                                            <tr> 
                                                                                <td colspan="5" class='title' style='text-align:right'>합 계&nbsp;&nbsp; 
                                                                                <%= AddUtil.parseDecimal(amt_sum+labor_sum) %>원&nbsp;</td>
                                                                                <td class='title' style='text-align:right'><%= AddUtil.parseDecimal(amt_sum) %>원&nbsp;</td>
                                                                                <td class='title' style='text-align:right'><%= AddUtil.parseDecimal(labor_sum) %>원&nbsp;</td>
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
                                                                    <td class='title' width=9%>공임</td>
                                                                    <td width=15% align=right><input type="text" name="r_labor" size="8" value='<%= AddUtil.parseDecimal(labor_sum) %>' class=whitenum readonly="true" >
                                                                      원&nbsp;</td>
                                                                    <td class='title' width=9%>부품</td>
                                                                    <td align=right width=15%>&nbsp; <input type="text" name="r_amt" size="8" value='<%= AddUtil.parseDecimal(amt_sum) %>' class=whitenum readonly="true"  >
                                                                      원&nbsp;</td>
                                                                    <td class='title' width=9%>부품DC</td>
                                                                    <td align=right width=15%>&nbsp; <input type="text" name="r_dc" size="9" class=whitenum  value="<%= AddUtil.parseDecimal(siBn.getR_dc()) %>" >
                                                                      %&nbsp;</td>
                                                                    <td class='title' width=9%>부품(정산)</td>
                                								    <td width=19%>&nbsp; <input type="text" name="r_j_amt" size="9" class=whitenum value="<%= AddUtil.parseDecimal(siBn.getR_j_amt()) %>" >
                                								    원</td>
                                                                </tr>	
                                                                <tr> 
                                                                    <td class='title'>공급가</td>
                                                                    <td align=right>&nbsp; <input type="text" name="sup_amt" size="8" class=whitenum  value="<%= AddUtil.parseDecimal(siBn.getSup_amt()) %>">
                                                                      원&nbsp;</td>
                                                                    <td class='title'>부가세</td>
                                                                    <td align=right>&nbsp; <input type="text" name="add_amt" size="8" class=whitenum value="<%= AddUtil.parseDecimal(siBn.getAdd_amt()) %>" >
                                                                      원&nbsp;</td>
                                                                    <td class='title'>정비금액</td>
                                                                    <td align=right>&nbsp; <input type="text" name="rep_amt" size="9" class=whitenum readonly="true" value="<%= AddUtil.parseDecimal(siBn.getRep_amt()) %>">
                                                                      원&nbsp;</td>                                                                        
                                                                    <td class='title'>-</td>
                                									                     <input type="hidden" name="item_sum" value="0">
                                                                    <td>&nbsp;</td>           									
                                                                  
                                                                </tr>
                                                                <tr> 
                                                                    <td class='title'>DC율</td>
                                                                    <td align=right>&nbsp; <input type="text" name="dc_rate" size="8" class=whitenum  value="<%= AddUtil.parseFloatCipher2(dc_rate,2) %>" >
                                                                      %&nbsp;</td>
                                                                    <td class='title'>DC</td>
                                                                    <td align=right>&nbsp; <input type="text" name="dc" size="8" class=whitenum value="<%= AddUtil.parseDecimal(siBn.getDc()) %>" >
                                                                      원&nbsp;</td>
                                                                    <td class='title'>지급금액</td>
                                                                    <td align=right>&nbsp; <input type="text" name="tot_amt" size="9" class=whitenum value="<%= AddUtil.parseDecimal(siBn.getTot_amt()) %>">
                                                                      원&nbsp;</td>
                                                                    <td class='title'>결제일</td>
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
      <td colspan="2">&nbsp;※ 법인카드로 결재되었습니다. (<%=serv_card.get("CARDNO")%> <%=serv_card.get("BUY_DT")%>)</td>
    </tr>			
	<%}%>															
	<%if(serv_reg_st.equals("Y")){%>						
    <tr> 
      <td colspan="2">&nbsp;※ 출금원장에서 약식등록되었습니다.(<%=serv_pay.get("REG_NM")%> <%=serv_pay.get("REG_DT")%>)</td>
    </tr>			
	<%}%>																															
	<%if(serv_reg_st.equals("S")){%>						
    <tr> 
      <td colspan="2">&nbsp;※ 출금원장에 출금등록되었습니다.(<%=serv_pay.get("REG_NM")%> <%=serv_pay.get("REG_DT")%>)</td>
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
                <td class='title' width=10%>원장번호</td>
                <td width=40%>&nbsp;&nbsp;<%=serv_pay.get("REQSEQ")%></td>
                <td class='title' width=10%>출금일자</td>
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
					<td class='title'>증빙서류<%=k+1%></td>						
    				<td colspan='3'>	&nbsp;<a href="javascript:openPopP('<%=ht2.get("FILE_TYPE")%>','<%=ht2.get("SEQ")%>');" title='보기' ><%=ht2.get("FILE_NAME")%></a>
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
	    <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>견적서 스캔</span></td>
	</tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr bgcolor="#FFFFFF"> 
                    <td class='title' width=10%>관리번호</td>
                    <td width=15% align="left">&nbsp;<%= siBn.getEstimate_num() %></td>
                    <td class='title' width=10%>견적서</td>
                    <td>&nbsp;
			<%if(attach_vt_size > 0){%>
			    <%	for (int j = 0 ; j < attach_vt_size ; j++){
    					Hashtable ht = (Hashtable)attach_vt.elementAt(j);%>
    					&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
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
