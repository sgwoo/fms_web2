<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.con_ins.*, cust.rent.*"%>
<jsp:useBean id="p_db" scope="page" class="cust.pay.PayDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");
	String s_gubun2 = request.getParameter("s_gubun2")==null?"":request.getParameter("s_gubun2");
	String s_gubun3 = request.getParameter("s_gubun3")==null?"":request.getParameter("s_gubun3");
	String s_gubun4 = request.getParameter("s_gubun4")==null?"":request.getParameter("s_gubun4");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String rent_cnt = request.getParameter("rent_cnt")==null?"":request.getParameter("rent_cnt");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String item_id = request.getParameter("item_id")==null?"":request.getParameter("item_id");
	
	
	
	Hashtable item = p_db.getDocCase(item_id);
	
	Vector items1 = p_db.getTaxItemList(item_id);
	int item_size1 = items1.size();
	
	Vector items2 = p_db.getTaxItemKiList(item_id);
	int item_size2 = items2.size();
	
	long item_s_amt1 = 0;
	long item_v_amt1 = 0;
	long item_s_amt2 = 0;
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="../../include/print.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post' action='tax_frame.jsp' target=''>
<input type='hidden' name="br_id" value="<%=br_id%>">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="member_id" value="<%=member_id%>">
<input type='hidden' name="client_id" value="<%=client_id%>">
<input type='hidden' name="r_site" value="<%=r_site%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="s_yy" value="<%=s_yy%>">
<input type='hidden' name="s_mm" value="<%=s_mm%>">
<input type='hidden' name="s_gubun1" value="<%=s_gubun1%>">
<input type='hidden' name="s_gubun2" value="<%=s_gubun2%>">
<input type='hidden' name="s_gubun3" value="<%=s_gubun3%>">
<input type='hidden' name="s_gubun4" value="<%=s_gubun4%>">
<input type='hidden' name="s_kd" value="<%=s_kd%>">
<input type='hidden' name="t_wd" value="<%=t_wd%>">
<input type='hidden' name="rent_cnt" value="<%=rent_cnt%>">
<input type='hidden' name="idx" value="<%=idx%>">
<input type='hidden' name="item_id" value="<%=item_id%>">
<input type='hidden' name="idx" value="<%=idx%>">
<!-- 여기까지 -->
<table border='0' cellspacing='0' cellpadding='0' width='800'>	
    <tr> 
        <td colspan="2"> 
            <table width='800' cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan=2>
                        <table width=100% border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                                <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객FMS > 인쇄정보 > <span class=style5>거래명세서 상세내역</span></span>
                    			</td>
                                <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=15></tD>
                </tr>
                <tr> 
                    <td align='right' colspan="2"><a href='javascript:history.go(-1);' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=../images/center/button_list.gif border=0 align=absmiddle></a></td>
                </tr>
                <tR>
                    <td height=3></td>
                </tr>
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>
                <tr> 
                    <td colspan="2" class=line> 
                        <table border="0" cellspacing="1" cellpadding='0' width=800>
                            <tr> 
                                <td width="100" align="center" height="20" class=title3>상호</font> 
                                </td>
                                <td width="300" height="20" class=b>&nbsp;<%=item.get("FIRM_NM")%></td>
                                <td width="100"  align="center" height="20" class=title3>사용본거지</td>
                                <td width="300"  height="20" class=b>&nbsp;<%=item.get("R_SITE")%></td>
                            </tr>
                        </table>
                    </td>
                </tr>		  
                <tr> 
                    <td height="2">&nbsp;</td>
                    <td align="right" height="2"></td>
                </tr>
                <tr> 
                    <td colspan="2">
                        <table width="700" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td style="border: #000000 2px solid" align="center" valign="middle"> 
                                    <table width="95%" border="0" cellspacing="0" cellpadding="0" height="95%">
                                        <tr> 
                                            <td height="20">&nbsp;</td>
                                            <td height="20">&nbsp;</td>
                                            <td height="20">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td width="260">&nbsp;</td>
                                            <td align="center" width="180" style="border-bottom: #000000 1px solid" height="30"><font size="5">거 
                                              래 명 세 서</font></td>
                                            <td width="260">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td>&nbsp;</td>
                                            <td align="center" height="25" valign="bottom">(고 객 용)</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td colspan="3"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="50%" height="40">&nbsp;</td>
                                                        <td width="5%">&nbsp;</td>
                                                        <td rowspan="2"> 
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td height="150" rowspan="5" width="30" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">공<br>
                                                                    <br>
                                                                    급<br>
                                                                    <br>
                                                                    자</td>
                                                                    <td height="30" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">등록번호</td>
                                                                    <td height="30" colspan="3" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-right: #000000 1px solid; border-bottom: #000000 1px solid">128-81-47957</td>
                                                                </tr>
                                                                <tr> 
                                                                    <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">상호</td>
                                                                    <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">(주)아마존카</td>
                                                                    <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">성명</td>
                                                                    <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">조성희</td>
                                                                </tr>
                                                                <tr> 
                                                                    <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">사업장주소</td>
                                                                    <td height="30" colspan="3" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">서울 
                                                                  영등포구 여의도동 17-3</td>
                                                                </tr>
                                                                <tr> 
                                                                    <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">업태</td>
                                                                    <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">서비스</td>
                                                                    <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">종목</td>
                                                                    <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">대여사업</td>
                                                                </tr>
                                                                <tr> 
                                                                    <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">대표전화</td>
                                                                    <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">02)392-4243</td>
                                                                    <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">팩스</td>
                                                                    <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">02-757-0803</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr> 
                                                        <td> 
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td height="22" width="20%">관&nbsp;리&nbsp;번&nbsp;호</td>
                                                                    <td height="22" width="5%" align="center">:</td>
                                                                    <td height="22" colspan="2">&nbsp;<%=item.get("ITEM_ID")%></td>
                                                                    <td height="22" width="17%">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                    <td height="22">작&nbsp;&nbsp;&nbsp;성&nbsp;&nbsp;&nbsp;일</td>
                                                                    <td height="22" align="center">:</td>
                                                                    <td height="22" colspan="2">&nbsp;<%=AddUtil.getDate3(String.valueOf(item.get("ITEM_DT")))%></td>
                                                                    <td height="22">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                    <td height="22">성호&nbsp;(성명)</td>
                                                                    <td height="22" align="center">:</td>
                                                                    <td height="22" colspan="3">&nbsp;<%=item.get("FIRM_NM")%>&nbsp;<%=item.get("R_SITE2")%></td>
                                                                </tr>
                                                                <tr> 
                                                                    <td height="22" colspan="5"><b>아래와 같이 계산합니다.</b></td>
                                                                </tr>
                                                                <tr> 
                                                                    <td height="22">합&nbsp;계&nbsp;금&nbsp;액</td>
                                                                    <td height="22" align="center">:</td>
                                                                    <td height="22" width="10%" style="border-bottom: #000000 1px solid">일금</td>
                                                                    <td height="22" style="border-bottom: #000000 1px solid" align="right" width="48%">&nbsp;<%=item.get("ITEM_HAP_STR")%></td>
                                                                    <td height="22" align="right" style="border-bottom: #000000 1px solid">정(①+②)</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td height="20" align="right">(￦<%=Util.parseDecimal(String.valueOf(item.get("ITEM_HAP_NUM")))%>)</td>
                                            <td height="30" rowspan="2">&nbsp;</td>
                                            <td height="30" align="right" rowspan="2">작성자 : &nbsp;&nbsp;<%=item.get("ITEM_MAN")%></td>
                                        </tr>
                                        <tr> 
                                            <td height="15" align="right">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td colspan="3"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr align="center" bgcolor="#CCCCCC"> 
                                                        <td rowspan="2" width="30" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">연번</td>
                                                        <td rowspan="2" width="80" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">거래구분</td>
                                                        <td rowspan="2" width="90" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">차량번호</td>
                                                        <td rowspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC">차명</td>
                                                        <td height="20" colspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">청구(거래)기준일</td>
                                                        <td rowspan="2" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">공급가액</td>
                                                        <td rowspan="2" width="60" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">세액</td>
                                                        <td rowspan="2" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">합계</td>
                                                    </tr>
                                                    <tr> 
                                                        <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~부터</td>
                                                        <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~까지</td>
                                                    </tr>
                                                <%		for(int i = 0 ; i < item_size1 ; i++){
                    										Hashtable item1 = (Hashtable)items1.elementAt(i);%>
                                                    <tr> 
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=item1.get("ITEM_SEQ")%></td>
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=item1.get("ITEM_G")%></td>
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=item1.get("ITEM_CAR_NO")%></td>
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=item1.get("ITEM_CAR_NM")%></td>
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=AddUtil.ChangeDate2(String.valueOf(item1.get("ITEM_DT1")))%></font></td>
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=AddUtil.ChangeDate2(String.valueOf(item1.get("ITEM_DT2")))%></font></td>
                                                        <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=Util.parseDecimal(String.valueOf(item1.get("ITEM_SUPPLY")))%>&nbsp;</td>
                                                        <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=Util.parseDecimal(String.valueOf(item1.get("ITEM_VALUE")))%>&nbsp;</td>
                                                        <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(item1.get("ITEM_SUPPLY")))+AddUtil.parseInt(String.valueOf(item1.get("ITEM_VALUE"))))%>&nbsp;</td>
                                                    </tr>
                                                <%			item_s_amt1 = item_s_amt1  + Long.parseLong(String.valueOf(item1.get("ITEM_SUPPLY")));
                    										item_v_amt1 = item_v_amt1  + Long.parseLong(String.valueOf(item1.get("ITEM_VALUE")));
                    									}%>
                                                <%		for(int i = 0 ; i < 16-item_size1 ; i++){%>
                                                    <tr> 
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                                        <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                                        <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                                        <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                                                    </tr>
                                                <%	}%>
                                                    <tr> 
                                                        <td height="22" colspan="6" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>합계(①)</b></font></td>
                                                        <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><%=Util.parseDecimal(item_s_amt1)%>&nbsp;</td>
                                                        <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><%=Util.parseDecimal(item_v_amt1)%>&nbsp;</td>
                                                        <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid" align="right"><%=Util.parseDecimal(item_s_amt1+item_v_amt1)%>&nbsp;</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td colspan="3"><font size="1">※ 일할계산(대여료) : (월대여료ⅹ대여일수)÷30일</font></td>
                                        </tr>
                                        <tr> 
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td><font size="3"><b>※ 기타</b></font></td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td colspan="3"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr align="center" bgcolor="#CCCCCC"> 
                                                        <td height="25" width="110" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">청구구분</td>
                                                        <td height="25" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC">적요</td>
                                                        <td height="25" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">금액</td>
                                                        <td height="25" width="130" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">비고</td>
                                                    </tr>
                                                    <%		for(int i = 0 ; i < item_size2 ; i++){
                        										Hashtable item2 = (Hashtable)items2.elementAt(i);%>
                                                    <tr> 
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=item2.get("ITEM_KI_G")%></td>
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=item2.get("ITEM_KI_APP")%></td>
                                                        <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=Util.parseDecimal(String.valueOf(item2.get("ITEM_KI_PR")))%>&nbsp;</td>
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;<%=item2.get("ITEM_KI_BIGO")%></td>
                                                    </tr>
                                                    <%			item_s_amt2 = item_s_amt2  + Long.parseLong(String.valueOf(item2.get("ITEM_KI_PR")));
                        									}%>
                                                    <%		for(int i = 0 ; i < 5-item_size2 ; i++){%>
                                                    <tr> 
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                                        <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                                        <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                                                    </tr>
                                                    <%	}%>
                                                    <tr> 
                                                        <td height="22" colspan="2" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>합계(②)</b></font></td>
                                                        <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><%=Util.parseDecimal(item_s_amt2)%>&nbsp;</td>
                                                        <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td height="20">&nbsp;</td>
                                            <td height="20">&nbsp;</td>
                                            <td height="20">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
        </table>
    </tr>
</table>
<DIV id=Layer1 style="Z-INDEX: 1; LEFT: 670px; WIDTH: 68px; POSITION: absolute; TOP: 205px; HEIGHT: 68px"><IMG src="../../images/cust/3c7kR522I6Sqs_70.gif"></DIV>
  </form>
<script language='javascript'>
<!--	
//-->
</script>
</body>
</html>