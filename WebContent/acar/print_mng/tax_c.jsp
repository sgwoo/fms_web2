<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
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
		
	String tax_no = request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Hashtable tax = p_db.getTaxCase(tax_no);
	
	String tax_supply = String.valueOf(tax.get("TAX_SUPPLY"));
	String tax_value = String.valueOf(tax.get("TAX_VALUE"));
	int tax_amt = AddUtil.parseInt(tax_supply)+AddUtil.parseInt(tax_value);
%>
<html>
<head>
<title>계약서</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
<input type='hidden' name="tax_no" value="<%=tax_no%>">
<!-- 여기까지 -->
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr> 
        <td colspan="2"> 
            <table width='100%' cellpadding="0" cellspacing="0">
        	    <tr>
				    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
				    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객FMS > 인쇄정보 > <span class=style5>
					세금계산서 상세내역</span></span></td>
					<td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>          
    <tr> 
        <td align='right' colspan="2"><a href='javascript:history.go(-1);' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="../images/center/button_list.gif" align="absmiddle" border="0"></a></td>
    </tr>
		  <%if(!String.valueOf(tax.get("RENT_L_CD")).equals("") && String.valueOf(tax.get("UNITY_CHK")).equals("0")){
		  		//계약:고객관련
				Hashtable cont_view = p_db.getLongRentCaseH(String.valueOf(tax.get("RENT_L_CD")));%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line height="105" colspan="2"> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title>차량번호</td>
                    <td>&nbsp;<font color="#003366"><b><%=cont_view.get("CAR_NO")%></b></font> 
                    </td>
                    <td class=title>차명</td>
                    <td colspan="3">&nbsp;<%=cont_view.get("CAR_NAME")%></td>
                </tr>
                <tr> 
                    <td class=title width=12%>계약번호</td>
                    <td>&nbsp;<%=cont_view.get("RENT_L_CD")%></td>
                    <td class=title width=12%>계약일자</td>
                    <td width=21%>&nbsp;<%=cont_view.get("RENT_DT")%></td>
                    <td class=title width=12%>영업소</td>
                    <td width=21%>&nbsp;<%=c_db.getNameById(String.valueOf(cont_view.get("BRCH_ID")),"BRCH")%></td>
                </tr>
                <tr> 
                    <td class=title align="center">대여상품</td>
                    <td colspan="3"> 
                    <%if(String.valueOf(cont_view.get("CAR_ST")).equals("1")){%>
                    &nbsp;장기렌트 
                    <%}else if(String.valueOf(cont_view.get("CAR_ST")).equals("2")){%>
                    &nbsp;보유차 
                    <%}else if(String.valueOf(cont_view.get("CAR_ST")).equals("3")){%>
                    &nbsp;리스플러스 
                    <%}%>
                    <%=cont_view.get("RENT_WAY")%> 
                    <%if(String.valueOf(cont_view.get("REG_ID")).equals("0")){%>
                    (보유차 대여) 
                    <%}%>
                    <%if(String.valueOf(cont_view.get("REG_ID")).equals("1")){%>
                    (신차 대여) 
                    <%}%>
                    </td>
                    <td class=title>대여기간</td>
                    <td>&nbsp;<%=cont_view.get("RENT_START_DT")%>~<%=cont_view.get("RENT_END_DT")%></td>
                  <!--	차량 등록 후 차량관리자 등록됨.. -->
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan=2></td>
    </tr>
    <tr> 
        <td width="50%"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객사항</span></td>
        <td align="right"></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class='title' width=12% height="21">상호&nbsp; </td>
                    <td class='left' width=38% height="21" >&nbsp;<%=cont_view.get("FIRM_NM")%></td>
                    <td class=title width=12% height="21">사용본거지</td>
                    <td class='left' width=38% height="21">&nbsp;<%=cont_view.get("R_SITE")%></td>
                </tr>
                <tr> 
                    <td class='title'>우편물주소</td>
                    <td class='left' colspan="3">&nbsp;<%=cont_view.get("P_ZIP")%>&nbsp;&nbsp;<%=cont_view.get("P_ADDR")%></td>
                </tr>
            </table>
        </td>
    </tr>
		  <%}else{%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class='title' width=12%>상호&nbsp; </td>
                    <td class='left' width=38% >&nbsp;<%=tax.get("FIRM_NM")%></td>
                    <td class=title width=12%>사용본거지</td>
                    <td class='left' width=38%>&nbsp;<%=tax.get("TAX_BIGO")%></td>
                </tr>
                <tr> 
                    <td class='title'>통합여부</td>
                    <td class='left' colspan="3" >&nbsp;통합발행</td>
                </tr>
            </table>
        </td>
    </tr>		  
		  <%}%>
    <tr>
        <td colspan=2></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>세금계산서</span></td>
        <td align="right"></td>
    </tr>
    <tr> 
        <td colspan="2"> 
            <table cellspacing=0 cellpadding=0 width=100% border=0>
                <tr> 
                    <td> 
                        <table width=620>
                            <tbody> 
                            <tr class=ledger_titleB> 
                                <td align=left><font color=#0166a9>[별지 제11호 서식]</font></td>
                                <td align=right><font color=#0166a9>(청 색)</font></td>
                            </tr>
                            </tbody> 
                        </table>
                        <table cellspacing=3 cellpadding=0 width=620 border=0>
                            <tr align=middle> 
                                <td colspan=4> 
                                    <table style="BORDER-COLLAPSE: collapse" cellspacing=0 bordercolordark=white cellpadding=0 width=620 bordercolorlight=#0166a9>
                                        <tbody> 
                                        <tr> 
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 0px solid" width=465 height=38 rowspan=2 align="center"> 
                                            <p>세 금 계 산 서 (공급받는자 보관용)</p>
                                            </td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=68 height=15 align="center">책 번 호</td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" align=right width=115 height=15>&nbsp; <font 
                                            color=#0166a9>권</font>&nbsp; <font 
                                            color=#0166a9>호</font></td>
                                        </tr>
                                        <tr> 
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" width=68 height=15 align="center">일련번호 </td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" width=115 height=15 align="center">&nbsp;<%=tax.get("TAX_NO")%> </td>
                                        </tr>
                                         </tbody>
                                    </table>
                                    <table style="BORDER-COLLAPSE: collapse" cellspacing=0 cellpadding=0 width="100%">
                                        <tbody> 
                                        <tr> 
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 0px solid" width=18 height=52 rowspan=4 align="center">공<br>
                                            <br>
                                            급<br>
                                            <br>
                                            자</td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" height=13 align="center" width="50">등록번호</td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 0px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=2 height=13><%=AddUtil.ChangeEnp(String.valueOf(tax.get("BR_ENT_NO")))%></td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 0px solid; BORDER-BOTTOM: #0166a9 1px solid" height=13 width="96"> 
                                                <table cellspacing=0 cellpadding=0 align=right border=0>
                                                    <tbody> 
                                                    <tr> 
                                                        <td width=40 height=1></td>
                                                    </tr>
                                                    </tbody> 
                                                </table>
                                            </td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" width=18 height=52 rowspan=4 align="center">공<br>
                                            급<br>
                                            받<br>
                                            는<br>
                                            자</td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" width=50 height=13 align="center">등록번호</td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" colspan=3 height=13><%=AddUtil.ChangeEnp(String.valueOf(tax.get("ENP_NO")))%></td>
                                        </tr>
                                        <tr> 
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" width=50 height=13 align="center"> 
                                            <p>상 호<br>
                                            (법인명)</p>
                                            </td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=96 height=13>주식회사아마존카 </td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=50 height=13 align="center">성 
                                                명<br>
                                                (대표자)</td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=96 height=13><%=tax.get("BR_OWN_NM")%></td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=50 height=13 align="center">상 
                                                호<br>
                                                (법인명)</td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=96 height=13><%=tax.get("FIRM_NM")%></td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=50 height=13 align="center">성 
                                                명<br>
                                                (대표자)</td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=96 height=13><%=tax.get("CLIENT_NM")%></td>
                                        </tr>
                                        <tr> 
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=50 height=13 align="center">사 
                                            업 장<br>
                                            주소 </td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=3><%=tax.get("BR_ADDR")%></td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=50 height=13 align="center">사 
                                            업 장<br>
                                            주소<br>
                                            </td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=3><%=tax.get("O_ADDR")%></td>
                                        </tr>
                                        <tr> 
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" width=50 height=13 align="center">업 
                                            태</td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" width=96 height=13><%=tax.get("BR_STA")%></td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" width=50 height=13 align="center">종 
                                            목</td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" width=96 height=13><%=tax.get("BR_ITEM")%></td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" width=50 height=13 align="center">업 
                                            태</td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" width=96 height=13><%=tax.get("BUS_CDT")%></td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" width=50 height=13 align="center">종 
                                            목</td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" width=96 height=13><%=tax.get("BUS_ITM")%></td>
                                         </tr>
                                        </tbody> 
                                    </table>
                                    <table style="BORDER-COLLAPSE: collapse" cellspacing=0 cellpadding=0 width=100%>
                                        <tbody> 
                                        <tr align="center"> 
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=3 height=13>작 성</td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=12 height=13>공 &nbsp;&nbsp;&nbsp;&nbsp;급 &nbsp;&nbsp;&nbsp;가 
                                            &nbsp;&nbsp;&nbsp;액</td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=10 height=13>세 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=185 height=13>비 
                                            &nbsp;고</td>
                                        </tr>
                                        <tr> 
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=40 height=15 align="center">년</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=20 height=15 align="center">월</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=20 height=15 align="center">일</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=40 height=15 align="center">공란수</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">백</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">십</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">억</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">천</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">백</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">십</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">만</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">천</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">백</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">십</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">일</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">십</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">억</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">천</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">백</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">십</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">만</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">천</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">백</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">십</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15 height=15 align="center">일</td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=185 height=34 rowspan=2><%=tax.get("TAX_BIGO")%></td>
                                        </tr>
                                        <tr> 
                                                <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" width=40 height=19 align="center"><%=String.valueOf(tax.get("TAX_DT")).substring(0,4)%></td>
                                                <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=20 height=19 align="center"><%=String.valueOf(tax.get("TAX_DT")).substring(4,6)%></td>
                                                <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=20 height=19 align="center"><%=String.valueOf(tax.get("TAX_DT")).substring(6,8)%></td>
                                                <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=40 height=19 align="center"><%=11-tax_supply.length()%></td>
                                                <%for(int i=0; i<11-tax_supply.length(); i++){%>
                                                <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=15 height=19 align="center"></td>
                                                <%}%>
                                                <%for(int i=0; i<tax_supply.length(); i++){%>
                                                <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=15 height=19 align="center"><%=tax_supply.charAt(i)%></td>
                                                <%}%>
                                                <%for(int i=0; i<10-tax_value.length(); i++){%>
                                                <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=15 height=19 align="center"></td>
                                                <%}%>
                                                <%for(int i=0; i<tax_value.length(); i++){%>
                                                <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=15 height=19 align="center"><%=tax_value.charAt(i)%></td>
                                                <%}%>
                                        </tr>
                                        </tbody> 
                                    </table>
                                    <table style="BORDER-COLLAPSE: collapse" cellspacing=0 bordercolordark=white cellpadding=0 width=100% bordercolorlight=#0166a9>
                                        <tbody> <tbody> 
                                        <tr> 
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=2 height=12 align="center">월&nbsp;&nbsp;일</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=267 height=12 align="center">품&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=29 height=12 align="center">규 
                                                격</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=40 height=12 align="center">수 
                                                량</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=52 height=12 align="center">단 
                                                가</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=76 height=12 align="center">공급가액</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=70 height=12 align="center">세 
                                                액</td>
                                                <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=46 height=12 align="center">비 
                                                고</td>
                                        </tr>
                                        <tr> 
                                                <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=20 height=15 align="center"><%=String.valueOf(tax.get("TAX_DT")).substring(4,6)%></td>
                                                <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=20 height=15 align="center"><%=String.valueOf(tax.get("TAX_DT")).substring(6,8)%></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=267 height=15>&nbsp; 
                                                <%=tax.get("TAX_G")%></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=29 height=15><nobr></nobr></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=40 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=52 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=76 height=15 align="right"><%=Util.parseDecimal(String.valueOf(tax.get("TAX_SUPPLY")))%></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=70 height=15 align="right"><%=Util.parseDecimal(String.valueOf(tax.get("TAX_VALUE")))%></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=46 height=15></td>
                                        </tr>
                                        <tr> 
                                                <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=20 height=15></td>
                                                <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=20 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=267 height=15>&nbsp; 
                                                </td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=29 height=15><nobr></nobr></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=40 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=52 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=76 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=70 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=46 height=15></td>
                                        </tr>
                                        <tr> 
                                                <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=20 height=15></td>
                                                <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=20 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=267 height=15>&nbsp; 
                                                </td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=29 height=15><nobr></nobr></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=40 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=52 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=76 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=70 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=46 height=15></td>
                                        </tr>
                                        <tr> 
                                                <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=20 height=15></td>
                                                <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=20 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=267 height=15>&nbsp; 
                                                </td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=29 height=15><nobr></nobr></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=40 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=52 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=76 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=70 height=15></td>
                                                <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=46 height=15></td>
                                        </tr>
                                        </tbody></tbody> 
                                    </table>
                                    <table style="BORDER-COLLAPSE: collapse" cellspacing=0 bordercolordark=white cellpadding=0 width=100% bordercolorlight=#0166a9>
                                        <tbody> <tbody> 
                                        <tr> 
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=100 height=11 align="center">합계금액</td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=100 height=11 align="center">현 
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;금</td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=100 height=11 align="center">수&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;표</td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=100 height=11 align="center">어&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;음</td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=100 height=11 align="center">외 
                                                상 미 수 금</td>
                                            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" align=middle width=116 height=40 rowspan=2> 
                                                <table cellspacing=0 cellpadding=0 width=120 border=0>
                                                    <tbody> 
                                                    <tr class=ledger_titleB> 
                                                        <td width="47%">이금액을</td>
                                                        <td width="45%"><img height=13 src="../../images/cust/spc.gif" width=13> 영수<br>
                                                        <img height=13 src="../../images/cust/img_check.gif" width=13> 청구 </td>
                                                        <td width="8%">함</td>
                                                    </tr>
                                                  </tbody> 
                                                </table>
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=23 align="right">&nbsp; 
                                                <%=Util.parseDecimal(tax_amt)%></td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=23 align="right">&nbsp; 
                                                <%=Util.parseDecimal(tax_amt)%></td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=23 align="right">&nbsp; 
                                                0 </td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=23 align="right">&nbsp; 
                                                0 </td>
                                            <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=23 align="right">&nbsp; 
                                                0 </td>
                                        </tr>
                                        </tbody></tbody> 
                                    </table>
                                    <table width=620>
                                        <tbody> 
                                        <tr class=ledger_titleB> 
                                        <td align=left><font color=#0166a9>22226-28132일 '96. 2. 
                                      27개정</font></td>
                                        <td align=right><font color=#0166a9>182mm X 128mm 인쇄용지(특급) 
                                      34g/m<sup>2</sup></font></td>
                                        </tr>
                                        </tbody> 
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
<%if(String.valueOf(tax.get("UNITY_CHK")).equals("0")){%>  
<DIV id=Layer1 style="Z-INDEX: 1; LEFT: 272px; WIDTH: 68px; POSITION: absolute; TOP: 360px; HEIGHT: 75px"><IMG src="../../images/cust/3c7kR522I6Sqs_70.gif"></DIV>
<%}else{%>  
<DIV id=Layer1 style="Z-INDEX: 1; LEFT: 272px; WIDTH: 68px; POSITION: absolute; TOP: 275px; HEIGHT: 75px"><IMG src="../../images/cust/3c7kR522I6Sqs_70.gif"></DIV>
<%}%>  	  							  
  </form>
<script language='javascript'>
<!--	
//-->
</script>
</body>
</html>