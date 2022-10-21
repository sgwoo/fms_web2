<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.short_fee_mng.*" %>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//저장하기
	function save(){
		var fm = document.form1;
		fm.submit();
	}
	
	//리스트 가기
	function go_to_list(){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;						
		location = "/acar/short_fee_mng/short_fee_mng_frame_s.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id;
	}	
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String section = request.getParameter("section")==null?"":request.getParameter("section");
	String reg_dt = request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	
	
	ShortFeeMngBean bean1 = sfm_db.getShortFeeMngCase(section, "1", reg_dt);
	ShortFeeMngBean bean2 = sfm_db.getShortFeeMngCase(section, "2", reg_dt);
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "11", "02", "04");
%>
<form action="short_fee_mng_u.jsp" name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="section" value="<%=section%>">
<input type="hidden" name="reg_dt" value="<%=reg_dt%>">
<input type="hidden" name="kind" value="<%=bean1.getKind()%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 단기대여 요금관리 > <span class=style5>단기대여 요금등록</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    <tr> 
        <td colspan="2" align="right"> <a href='javascript:save();'><img src=../images/center/button_modify_s.gif align=absmiddle border=0></a> 
        <a href='javascript:go_to_list();'><img src=../images/center/button_list.gif align=absmiddle border=0></a></td>
    </tr>
    <%}else{%>
    <tr> 
        <td colspan="2"></td>
    </tr>	
	<%}%>
    <tr> 
        <td colspan="2">
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class='line' width="100%">
                        <table  border=0 cellspacing=1 width="100%">
                            <tr> 
                                <td class=title width='128'>차량구분</td>
                                <td width='167' align="center"><%=bean1.getNm()%></td>
                                <td class=title width='130'>코드</td>
                                <td width="120" align="center" ><%=bean1.getSection()%></td>
                                <td class=title width="130">기준차량</td>
                                <td>&nbsp;<input type="text" name="stand_car" value="<%=bean1.getStand_car()%>" size="40" class=whitetext> 
                              </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan=2>* 기준일자 : <%=reg_dt%></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;<img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>요금표</span></td>
        <td align="right"><font color="#FF0000">부가세별도</font></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td colspan="2" class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=130>구분</td>
                    <td class=title>12시간</td>
                    <td class=title>1일</td>
                    <td class=title>2일</td>
                    <td class=title>3일</td>
                    <td class=title>4일</td>
                    <td class=title>5일</td>
                    <td class=title>6일</td>
                    <td class=title>7일</td>
                    <td class=title>8일</td>
                    <td class=title>9일</td>
                    <td class=title>10일</td>
                </tr>
                <%if(AddUtil.parseInt(bean1.getReg_dt()) < 20211027){ %>
                <tr> 
                    <td class=title>대여요금 총액</td>
                    <td align="center"> <input type="text" name="amt_12h" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_12h())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_01d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_01d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_02d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_02d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_03d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_03d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_04d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_04d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_05d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_05d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_06d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_06d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_07d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_07d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_08d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_08d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_09d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_09d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_10d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_10d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                </tr>
                <%} %>
                <tr> 
                    <td class=title>1일 대여요금</td>
                    <td align="center"> <input type="text" name="amt_12h" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_12h())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_01d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_01d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_02d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_02d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_03d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_03d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_04d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_04d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_05d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_05d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_06d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_06d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_07d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_07d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_08d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_08d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_09d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_09d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_10d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_10d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                </tr>
                <tr> 
                    <td colspan="12" height="10"></td>
                </tr>
                <tr> 
                    <td class=title>구분</td>
                    <td class=title>-</td>
                    <td class=title>11일</td>
                    <td class=title>12일</td>
                    <td class=title>13일</td>
                    <td class=title>14일</td>
                    <td class=title>15일</td>
                    <td class=title>16일</td>
                    <td class=title>17일</td>
                    <td class=title>18일</td>
                    <td class=title>19일</td>
                    <td class=title>20일</td>
                </tr>
                <%if(AddUtil.parseInt(bean1.getReg_dt()) < 20211027){ %>
                <tr> 
                    <td class=title>대여요금 총액</td>
                    <td align="center">- </td>
                    <td align="center"> <input type="text" name="amt_11d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_11d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_12d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_12d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_13d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_13d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_14d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_14d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_15d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_15d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_16d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_16d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_17d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_17d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_18d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_18d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_19d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_19d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_20d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_20d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                </tr>
                <%} %>
                <tr> 
                    <td class=title>1일 대여요금</td>
                    <td align="center">- </td>
                    <td align="center"> <input type="text" name="amt_11d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_11d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_12d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_12d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_13d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_13d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_14d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_14d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_15d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_15d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_16d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_16d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_17d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_17d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_18d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_18d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_19d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_19d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_20d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_20d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                </tr>
                <tr> 
                    <td colspan="12" height="10"></td>
                </tr>
                <tr> 
                    <td class=title>구분</td>
                    <td class=title>-</td>
                    <td class=title>21일</td>
                    <td class=title>22일</td>
                    <td class=title>23일</td>
                    <td class=title>24일</td>
                    <td class=title>25일</td>
                    <td class=title>26일</td>
                    <td class=title>27일</td>
                    <td class=title>28일</td>
                    <td class=title>29일</td>
                    <td class=title>30일</td>
                </tr>
                <%if(AddUtil.parseInt(bean1.getReg_dt()) < 20211027){ %>
                <tr> 
                    <td class=title>대여요금 총액</td>
                    <td align="center">- </td>
                    <td align="center"> <input type="text" name="amt_21d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_21d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_22d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_22d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_23d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_23d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_24d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_24d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_25d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_25d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_26d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_26d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_27d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_27d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_28d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_28d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_29d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_29d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_30d" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_30d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                </tr>
                <%} %>
                <tr> 
                    <td class=title>1일 대여요금</td>
                    <td align="center">- </td>
                    <td align="center"> <input type="text" name="amt_21d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_21d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_22d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_22d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_23d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_23d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_24d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_24d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_25d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_25d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_26d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_26d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_27d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_27d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_28d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_28d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_29d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_29d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_30d" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_30d())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                </tr>
                <tr> 
                    <td colspan="12" height="10"></td>
                </tr>
                <tr> 
                    <td class=title>구분</td>
                    <td class=title>1개월</td>
                    <td class=title>2개월</td>
                    <td class=title>3개월</td>
                    <td class=title>4개월</td>
                    <td class=title>5개월</td>
                    <td class=title>6개월</td>
                    <td class=title>7개월</td>
                    <td class=title>8개월</td>
                    <td class=title>9개월</td>
                    <td class=title>10개월</td>
                    <td class=title>11개월</td>
                </tr>
                <%if(AddUtil.parseInt(bean1.getReg_dt()) < 20211027){ %>
                <tr> 
                    <td class=title>대여요금 총액</td>
                    <td align="center"> <input type="text" name="amt_01m" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_01m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_02m" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_02m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_03m" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_03m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_04m" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_04m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_05m" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_05m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_06m" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_06m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_07m" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_07m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_08m" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_08m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_09m" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_09m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_10m" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_10m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_11m" size="10" value="<%=AddUtil.parseDecimal(bean1.getAmt_11m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                </tr>
                <%} %>
                <tr> 
                    <td class=title>1개월 대여요금</td>
                    <td align="center"> <input type="text" name="amt_01m" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_01m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_02m" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_02m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input typde="text" name="amt_03m" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_03m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_04m" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_04m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_05m" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_05m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_06m" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_06m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_07m" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_07m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_08m" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_08m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_09m" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_09m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_10m" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_10m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                    <td align="center"> <input type="text" name="amt_11m" size="10" value="<%=AddUtil.parseDecimal(bean2.getAmt_11m())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                </tr>
            </table>
        </td>
        <td>&nbsp;</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>