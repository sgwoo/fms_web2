<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.cont.*, acar.common.*" %>
<%@ page import="acar.cus0401.*, acar.insur.*, acar.car_register.*,  acar.cus_reg.*" %>
<jsp:useBean id="cnd" scope="session" class="acar.common.ConditionBean"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"21":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_bus = request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String s_brch = request.getParameter("s_brch")==null?"":request.getParameter("s_brch");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");	
	
	/*바로가기*/
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	if(!rent_mng_id.equals("") && m_id.equals("")) m_id = rent_mng_id;
	if(!rent_l_cd.equals("")   && l_cd.equals("")) l_cd = rent_l_cd;
	if(!car_mng_id.equals("")  && c_id.equals("")) c_id = car_mng_id;
	
	ContBaseBean base = a_db.getContBaseAll(m_id, l_cd);
	
	if(c_id.equals(""))		c_id 		= base.getCar_mng_id();
	if(client_id.equals(""))	client_id 	= base.getClient_id();
	/*바로가기*/
	
	Cus0401_Database cusDb = Cus0401_Database.getInstance();
	Cus0401_carinfoBean carinfoBn = cusDb.getCarinfo(car_mng_id, l_cd);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	CarInfoBean carinfoBn2 = cr_db.getCarInfo(car_mng_id);
	//차량정보
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	//보험정보
	String ins_st = "";
	String ins_com_nm = "";
	
	//차량등록정보&보험
	if(!car_mng_id.equals("")){
		ins_st 	= ai_db.getInsSt(car_mng_id);
		ins 	= ai_db.getIns(car_mng_id, ins_st);
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
function regMaint(auth_rw,car_mng_id){
	var SUBWIN="./cus0401_d_sc_regMaint.jsp?auth_rw=<%= auth_rw %>&car_mng_id=<%= car_mng_id %>&rent_mng_id=<%= rent_mng_id %>&rent_l_cd=<%= rent_l_cd %>";
	window.open(SUBWIN, "MaintReg", "left=200, top=200, width=370, height=180, scrollbars=no");		
}
function car_no_his(car_no){
	var SUBWIN="./cus0401_d_sc_car_no_his.jsp?auth_rw=<%= auth_rw %>&car_mng_id=<%= car_mng_id %>&rent_mng_id=<%= rent_mng_id %>&rent_l_cd=<%= rent_l_cd %>&car_no="+car_no;
	window.open(SUBWIN, "MaintReg", "left=100, top=200, width=750, height=400, scrollbars=yes");
}
function go_to_list()
	{
		var fm = document.form1;
		var url = "?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_bus=<%=s_bus%>&s_brch=<%=s_brch%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>";
		location='/acar/cus0401/cus0401_s_frame.jsp'+url;
	}
	function view_ins()
	{
		window.open("../ins_mng/ins_u_frame.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>&c_id=<%=car_mng_id%>&cmd=view", "VIEW_INS", "left=100, top=100, width=850, height=700, scrollbars=yes");
	}
	
	//자동차등록정보 보기
	function view_car()
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%= rent_mng_id %>&rent_l_cd=<%= rent_l_cd %>&car_mng_id=<%= car_mng_id %>&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");
	}				
//-->
</script>
</head>

<body leftmargin=15>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > 자동차관리 > <span class=style5>자동차정비조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td>
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기본정보</span></td>
                    <td align=right>
                      <a href="javascript:car_no_his('<%= c_db.getNameById(car_mng_id, "CAR_NO") %>');"><img src="/acar/images/center/button_carnum.gif" align="absmiddle" border="0"></a>
                      &nbsp;<a href="javascript:go_to_list()"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td class="line">
                        <table cellspacing="1" cellpadding='0' border="0" width="100%">
                            <tr> 
                                <td class=title>차량번호</td>
                                <td>&nbsp;<a href="javascript:view_car('<%=car_mng_id%>')" onMouseOver="window.status=''; return true" title='자동차등록상세내역을 팝업합니다.'><b><%= carinfoBn.getCar_no() %></b></a></td>
                                <td class=title>차명</td>
                                <td colspan="5">&nbsp;<b><%= carinfoBn.getCar_jnm()+" "+carinfoBn.getCar_nm() %></b> </td>
                                <td class=title>최초등록일</td>
                                <td>&nbsp;<%= AddUtil.ChangeDate2(carinfoBn.getInit_reg_dt()) %></td>
                            </tr>
                            <tr> 
                                <td width=10% class=title>차대번호</td>
                                <td width=16%>&nbsp;<%= carinfoBn.getCar_num() %></td>
                                <td class="title" width=7%>차종</td>
                                <td width=10%><%=c_db.getNameByIdCode("0041", "", carinfoBn.getCar_kd())%></td>
                                <td width=7% class=title>형식</td>
                                <td width=12%>&nbsp;<%= carinfoBn.getCar_form() %></td>
                                <td width=7% class=title>연식</td>
                                <td width=10%>&nbsp;<%= carinfoBn.getCar_y_form() %></td>
                                <td width=9% class=title>원동기형식</td>
                                <td width=11%>&nbsp;<%= carinfoBn.getMot_form() %></td>
                            </tr>
                            <tr> 
                                <td class=title>연료</td>
                                <td><b> 
                                  &nbsp;<%=c_db.getNameByIdCode("0039", "", carinfoBn.getFuel_kd())%>                                  
                                  </b> </td>
                                <td class="title" >연비</td>
                                <td>&nbsp;<%=carinfoBn.getConti_rat()%>km/ℓ</td>
                                <td class=title>배기량</td>
                                <td>&nbsp;<%= carinfoBn.getDpm() %> cc</td>
                                <td class=title>색상</td>
                                <td>&nbsp;<%= carinfoBn.getColo() %></td>
                                <td class=title>용도</td>
                                <td> <%if(carinfoBn.getCar_use().equals("1")){%>
                                  &nbsp;영업용 
                                  <%}else if(carinfoBn.getCar_use().equals("2")){%>
                                  &nbsp;자가용 
                                  <%}%> </td>
                            </tr>
							<tr> 
								<td class=title colspan="">검사유효기간</td>
								<td colspan="3" align='center'>&nbsp; 
								  <input type="text" name="maint_st_dt" value="<%=AddUtil.ChangeDate2(carinfoBn2.getMaint_st_dt())%>" size="10" class=whitetext>
								  ~ 
								  <input type="text" name="maint_end_dt" value="<%=AddUtil.ChangeDate2(carinfoBn2.getMaint_end_dt())%>" size="10" class=whitetext>
								  &nbsp; 
								</td>
								<td class=title>차령만료일</td>
								<td>&nbsp; 
									<input type="text" name="car_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(cr_bean.getCar_end_dt()))%>" size="10" class=whitetext>
								</td>
								<td class=title colspan="2">점검유효기간</td>
								<td colspan="3" align='center'>&nbsp; 
								  <input type="text" name="test_st_dt" value="<%=cr_bean.getTest_st_dt()%>" size="10" class=whitetext>
								  ~&nbsp; 
								  <input type="text" name="test_end_dt" value="<%=cr_bean.getTest_end_dt()%>" size="10" class=whitetext>
								</td>
							</tr>
                            <tr> 
                                <td class=title>추가선택사양</td>
                                <td colspan="9">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험내용</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td class="line">
                        <table width="100%" border="0" cellspacing="1" cellpadding='0'>
                            <tr> 
                                <td width="10%" class=title>보험회사</td>
                                <td width="12%">&nbsp;<a href="javascript:view_ins()"><%= carinfoBn.getIns_com_nm() %></a></td>
                                <td width="9%" class=title>보험기간</td>
                                <td width="17%">&nbsp;<%= AddUtil.ChangeDate2(carinfoBn.getIns_start_dt()) %> ~ <%= AddUtil.ChangeDate2(carinfoBn.getIns_exp_dt()) %></td>
                                <td width="14%" class=title>긴급전화번호</td>
                                <td width="14%">&nbsp;<%= carinfoBn.getAgnt_imgn_tel() %></td>
                                <td width="10%" class=title>사고전화번호</td>
                                <td width="14%">&nbsp;<%= carinfoBn.getAcc_tel() %></td>
                            </tr>
                            <tr> 
                                <td class=title>운전자연령</td>
                                <td> <% if(carinfoBn.getAge_scp().equals("1")){ %>
                                  &nbsp;21세 이상 
                                  <% }else if(carinfoBn.getAge_scp().equals("2")){ %>
                                  &nbsp;26세 이상 
                                  <% }else if(carinfoBn.getAge_scp().equals("2")){ %>
                                  &nbsp;모든 운전자 
                                  <% } %> </td>
                                <td class=title>대차범위</td>
                                <td>&nbsp;</td>
                                <td class=title>자기차량손해면책금</td>
                                <td colspan="3">&nbsp;<%= AddUtil.parseDecimal(carinfoBn.getVins_cacdt_amt()) %>원</td>
                            </tr>
                            <tr> 
                                <td class=title>피보험자</td>
                                <td colspan="3">&nbsp;<%if(ins.getCon_f_nm().equals("아마존카")){%><%=ins.getCon_f_nm()%><%}else{%><b><font color='#990000'><%=ins.getCon_f_nm()%></font></b><%}%> </td>
                                <td class=title>자기차량손해</td>
                                <td colspan="3">&nbsp;<%if(ins.getVins_cacdt_cm_amt()>0){%>
					<b><font color='#990000'>
가입 ( 차량 <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>만원, 자기부담금 <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>만원)
                    </font></b>
					<%}else{%>
                    -
                    <%}%></td>
                            </tr>							
                            <tr> 
                                <td class=title>특약사항</td>
                                <td colspan="7">
                                <%if(carinfoBn.getVins_spe().equals("")){%>
        										&nbsp;없음
        										<% }else{ %>
        										&nbsp;<%= carinfoBn.getVins_spe() %>
        										<% } %></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><iframe src="./cus0401_d_sc_carmgr.jsp?auth_rw=<%= auth_rw %>&car_mng_id=<%= car_mng_id %>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_way=<%=base.getRent_way()%>" name="inner1" width="100%" height="150" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" scrolling="no"></iframe></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><iframe src="./cus0401_d_sc_carhis.jsp?auth_rw=<%= auth_rw %>&car_mng_id=<%= car_mng_id %>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>" name="inner2" width="100%" height="250" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" scrolling="no"></iframe></td>
    </tr>
    <%if(!cr_bean.getDist_cng().equals("")){%>
    <tr>
      <td><font color=green><b>* <%=cr_bean.getDist_cng()%></b></font></td>
    </tr>
    <%}%>    
</table>
<script language='javascript'>
<!--
	//바로가기
	var s_fm = parent.top_menu.document.form1;
	s_fm.m_id.value = '<%=m_id%>';
	s_fm.l_cd.value = '<%=l_cd%>';	
	s_fm.c_id.value = '<%= c_id %>';
	s_fm.auth_rw.value = '<%= auth_rw %>';
	s_fm.user_id.value = '<%=user_id%>';
	s_fm.br_id.value = '<%=br_id%>';		
	s_fm.client_id.value = '<%=client_id%>';	
	s_fm.accid_id.value = "";
	s_fm.serv_id.value = "";
	s_fm.seq_no.value = "";
//-->
</script>  
</body>
</html>
