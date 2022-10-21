<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<jsp:useBean id="olyBean" class="acar.offls_pre.Offls_preBean" scope="page"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>


<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	
	Offls_preBean olyb[] = olpD.getPre_lst(gubun, gubun_nm, brch_id);
	
	
	int totCsum = 0;
	int totFsum = 0;
	
	String actn_cnt = ""; //반출시 경매회차
/*추가 - gill sun */
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String actn_id = olpD.getActn_id(car_mng_id);
	
	if(cmd.equals("")){
		olyBean = olpD.getPre_detail(car_mng_id); //매각결정차량현황에서 보증서 출력시
	}else{
		olyBean = olpD.getPre_detail2(car_mng_id); //출품현황에서 보증서 출력시
	}
	
	String car_no = olyBean.getCar_no();
	
	int a=1000;

%>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>품질보증서</title>
<style type=text/css>
<!--
.style1 {
	font-size: 13px;
	font-weight: bold;
}
.style2 {
	font-size: 11px;
	font-weight: bold;
}
.style4 {
	color: #C00000;
	font-size: 11px;
	font-weight: bold;
}
.style6 {
color: #C00000;}

.style3 {
color:26329e;
font-weight: bold;
}

.style5 {
	color: #000000;
	font-size: 11px;
}
-->
</style>
<link href=/include/style_home.css rel=stylesheet type=text/css>
</head>
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<body topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0>
<form name='form1' method='post' action=''>


<div>
<table width=754 border=0 cellpadding=18 cellspacing=1 bgcolor=5B608C>
    <tr>
        <td bgcolor=#FFFFFF valign=top align=center>
            <table width=708 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=20% align=center><img src=/acar/images/logo_1.png></td>
                    <td align=right valign=bottom>관리번호 : <%=olyBean.getCar_doc_no()%> 호</td>
                </tr>
                <tr>
                    <td height=7 colspan=2 align=center></td></tr>
                <tr>
                    <td colspan=2><img src=/acar/images/content/bar2.gif width=708 height=37></td>
                </tr>
                <tr align=center>
                    <td colspan=2>
                        <table width=690 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=28>(주)아마존카에서 판매한 자동차에 대한 보증 내용은 아래와 같습니다. </td>
                            </tr>
                            <tr>
                                <td height=12><span class=style1>1. 중고차자동차 품질 보증내용</span></td>
                            </tr>
                            <tr>
                                <td height=20>아래와 같이 무상보증 수리를 해 드립니다. </td>
                            </tr>
                            <tr>
                                <td height=20>
                                    <table width=690 border=0 cellpadding=0 cellspacing=1 bgcolor=cde83a>
                                        <tr>
                                            <td width=20% align=center bgcolor=e4f778><span class=style2><font color=4e6101>보증범위</font></span></td>
                                            <td height=48 bgcolor=#FFFFFF style="font-size:11px">&nbsp;&nbsp;&nbsp;구입 후 보증기간 내에 발생한 엔진 및 트랜스미션을 포함한 내구성 부품의 고장수리<br>
                                                &nbsp;&nbsp;&nbsp;(단, 도장, 콤비네이션램프 등 외관 및 소모성 부품은 제외)<br>
                                                &nbsp;&nbsp;&nbsp;* 당사와 사전 협의 없이 수리, 부품의 교환 등 임의 정비한 경우 보상하지 않습니다.</td>
                                        </tr>
                                        <tr>
                                            <td align=center bgcolor=e4f778><span class=style2><font color=4e6101>보증기간</font></span></td>
                                            <td height=48 bgcolor=#FFFFFF style="font-size:11px">&nbsp;&nbsp;&nbsp;보증기간 : 낙찰일로부터 7일<br>
                                                &nbsp;&nbsp;&nbsp;주행거리 : 총 주행거리 <%=AddUtil.parseDecimal(AddUtil.parseInt((String)olyBean.getKm())+1000)%>km 이내 (현재 주행거리 = <%=AddUtil.parseDecimal((String)olyBean.getKm())%>km)<br>
                                                &nbsp;&nbsp;&nbsp;* 상기 날짜 또는 주행거리 중 먼저 도래한 것을 보증기간 만료로 간주</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=3></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style1>2. 보증수리</span></td>
                            </tr>
                            <tr>
                                <td height=20 style="font-size:11px">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;① 보증수리는 당사에 입고하여 처리하는것을 원칙으로 합니다. <br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;② 현장수리<br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 무상보증 수리를 현장에서 할 경우 사전에 당사와 협의 하셔야 합니다.                            <br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 자동차 제작사가 지정한 정비업소에서 수리해야 합니다.                            <br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 거래명세서(견적서), 세금계산서가 반드시 선취 되어야 합니다.<br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 수리비용은 당사가 정비업소에 직접 지불합니다.<br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 기타 자세한 사항은 당사의 자동차 매각 담당자와 협의 하십시오.<br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;③ 당사에 입고 수리시 수리비용을 제외한 제반 부대비용(탁송료,유류비 등)은 고객님의 부담입니다.</td>
                            </tr>
                            <tr>
                                <td height=22><span class=style1>3. 보증 대상 차량</span></td>
                            </tr>
                            <tr>
                                <td height=20>
                                    <table width=690 border=0 cellpadding=0 cellspacing=1 bgcolor=cde83a>
                                        <tr align=center>
                                            <td width=20% height=20 bgcolor=e4f778><span class=style2><font color=4e6101>차 종</font></span></td>
                                            <td width=30% bgcolor=#FFFFFF><span class=style4><%=olyBean.getCar_jnm()%></span></td>
                                            <td width=20% bgcolor=e4f778><span class=style2><font color=4e6101>차량번호</font></span></td>
                                            <td bgcolor=#FFFFFF><span class=style4><%=olyBean.getCar_no()%></span></td>
                                        </tr>
                                        <tr align=center>
                                            <td height=20 bgcolor=e4f778><span class=style2><font color=4e6101>신차가격</font></span></td>
                                            <td bgcolor=#FFFFFF style="font-size:11px">&nbsp;\ <%=AddUtil.parseDecimal(olyBean.getCar_cs_amt() + olyBean.getCar_cv_amt() + olyBean.getSd_cs_amt() + olyBean.getSd_cv_amt())%></td>
                                            <td bgcolor=e4f778><span class=style2><font color=4e6101>차대번호</font></span></td>
                                            <td bgcolor=#FFFFFF style="font-size:11px"><%=olyBean.getCar_num()%></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=2></td>
                            </tr>
                            <tr>
                                <td height=25><span class=style1>4. 보증하는 자동차의 이력 : 없음</span></td>
                            </tr>
                            <tr>
                                <td height=18><span class=style1>5. 보증하는 자동차의 사고이력 : 첨부</span></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style6>위 보증대상 자동차에 대한 기재내용이 사실임을 확인하며, 위 보증사항을 충실히 이행할 것을 확약합니다. </span></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan=2><img src=/acar/images/content/bar1.gif width=708 height=37></td>
                </tr>
                <tr align=center>
                    <td colspan=2 height=340>
                        <table width=690 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=28>아래와 같이 상기 자동차를 낙찰받은 고객님께 풋 옵션(Put Option)의 권리를 부여합니다.</td>
                            </tr>
                            <tr>
                                <td  valign=top>
                                    <table width=690 border=0 cellspacing=0 cellpadding=0 background=/acar/images/content/put.JPG height=325>
                                        <tr>
                                            <td>
                                                <table width=690 border=0 cellpadding=0 cellspacing=0>
                                                    <tr>
                                                        <td height=17></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=198>&nbsp;</td>
                                                        <td width=421><font color=FFFFFF><b>풋옵션이란?</b></font></td>
                                                        <td width=39>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td height=10 colspan=3></td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp;</td>
                                                        <td style="font-size:11px">
                                                        고객님께서 당사가 출품한 자동차를 낙찰 받았으나, 낙찰 받은 자동차를 일정기간이<br>
                                                        경과하도록 처분하지 못한경우, 당해 자동차를 당사에 반납하고 낙찰대금의 95%를<br>
                                                        환불받는획기적인 거래조건입니다. 이는 당사가 업계 최초로 개발 시행하였으며,당<br>
                                                        사 전 출품차량에 권리를 제공합니다. 당사가 출품하는 모든 자동차에 제공하는 품<br>
                                                        질보증서 및 재구입 보증서는 혹시 있을 고객님의 손실을 최소화하고, 수익의 극대<br>화를 보증해주는 당사 차량만이 갖는 슈퍼프리미엄서비스입니다.<br><font color=999999>(시행일자:2008년 04월 25일)</font></td>
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=11></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=100% border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td width=56>&nbsp;</td>
                                                        <td width=288 valign=top>
                                                            <table width=100% border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td><span class=style3>행사기간</span> <span class=style5>: 낙찰일로부터 52일 ~56일째 (초일불산입)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    (8주차 월 ~ 금요일임)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=7></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style3>옵션행사에 따른 낙찰대금 환불</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=5></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>1. 환불일자 : 당해 자동차와 낙찰시 발급된 옵션거래 증<br>&nbsp;&nbsp;&nbsp;&nbsp;명서가 지정(경매장, 당사 차고지 등)한 장소에 반환<br>&nbsp;&nbsp;
                                                                    &nbsp;이 완료된 당일 (은행마감시간 기준,당사근무일 기준)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=3></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>2. 환불금액 : 낙찰가격의 95%(십원단위 절사)<br>&nbsp;&nbsp;&nbsp;&nbsp;(단, 고객님이 부담한 낙찰수수료, 탁송료, 유류비 등<br>&nbsp;&nbsp;&nbsp;&nbsp;부대비용은 제외)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=3></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>3. 환불조건 : 제3의 낙찰자 또는 제3자에게 명의 이전이<br>&nbsp;&nbsp;&nbsp;&nbsp;가능하도록 이전서류 제출 및 협조</span></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width=25>&nbsp;</td>
                                                        <td width=320>
                                                            <table width=100% border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td><span class=style3>행사방법</span><span class=style5> : 당사에 옵션행사 의사표시 (유,무선으로 당<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;사의관리 담당자에게 의사 표시 또는 우편,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;팩스를 이용)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=9></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style3>옵션행사 거절 사유</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=5></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>1. 주행거리 : &nbsp;&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)olyBean.getKm())+1000)%>km 초과<br>&nbsp;&nbsp;&nbsp;&nbsp;(낙찰시 주행거리 대비 1000km 초과임)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=2></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>2. 차량손상사고 발생시</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=2></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>3. 제3자에게 양도된 경우 (상사이전 제외)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=11></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style3>옵션행사 시 부대비용<br>(탁송료, 유류비용 등은 고객부담)</span></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=25></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr align=center>
                    <td colspan=2>
                        <table width=670 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td height=20 align=right colspan=2><%=AddUtil.getDate3(Util.getDate())%>&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=right valign=middle width=83%><span class=style1>주식회사 아마존카 대표이사</span></td>
                                <td align=right><img src=/acar/images/content/sign.gif  align=absmiddle></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=15 colspan=2>&nbsp;&nbsp;<span class=style6>※ 발행일자와 날인이 없거나, 임의 수정한 것은 무효입니다.</span></td>
                </tr>
                <tr>
                    <td height=15 colspan=2>&nbsp;&nbsp;서울 영등포구 여의도동 17-3 까뮤이앤씨빌딩 8층 ( http://www.amazoncar.co.kr)  &nbsp;&nbsp;TEL. 02) 392-4243 / FAX. 02) 757-0803</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</div>
</body>
</html>

<script>
onprint();

function onprint(){
factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 5.0; //좌측여백   
factory.printing.topMargin = 5.0; //상단여백    
factory.printing.rightMargin = 5.0; //우측여백
factory.printing.bottomMargin = 5.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>


