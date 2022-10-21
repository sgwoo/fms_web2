<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_actn.*"%>
<%@ page import="acar.common.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_actn.Offls_actnBean"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	detail = olaD.getActn_detail(car_mng_id);
	
	int a=1000;

%>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>출품신청서</title>
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
<link href=/include/style_opt.css rel=stylesheet type=text/css>
</head>

<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/ScriptX.cab" >
</object>
<body topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0>
<form name='form1' method='post' action=''>

<div>
<table width=754 border=0 cellpadding=0 cellspacing=0>
    <tr>
        <td bgcolor=#FFFFFF valign=top align=center>
            <table width=714 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=15></td>
                </tr>
                <tr>
                    <td>
                        <table width=714 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td width=428 align=center rowspan=3><img src=/acar/images/content/name.gif></td>
                                <td align=right>
                                    <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                                        <tr>
                                            <td width=25% align=center bgcolor=#FFFFFF height=24>출 품 일</td>
                                            <td bgcolor=#FFFFFF align=center><%=AddUtil.getDate2(1)%> &nbsp;&nbsp;&nbsp;&nbsp;년&nbsp;&nbsp; <%=AddUtil.getDate2(2)%>&nbsp;&nbsp;&nbsp;&nbsp;월&nbsp;&nbsp; <%=AddUtil.getDate2(3)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;일</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=7></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                                        <tr>
                                            <td width=25% align=center bgcolor=#FFFFFF height=24>접수번호</td>
                                            <td bgcolor=#FFFFFF>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width=25% align=center bgcolor=#FFFFFF height=24>출품번호</td>
                                            <td bgcolor=#FFFFFF>&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=12></td>
                </tr>
                <tr>
                    <td>
                        <table width=714 border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                            <tr>
                                <td bgcolor=#dddddd height=24 width=8% align=center><b>차 명</b></td>
                                <td bgcolor=#FFFFFF colspan=2>&nbsp;<%=detail.getCar_jnm() + " " +detail.getCar_nm() %></td>
                                <td bgcolor=#dddddd width=6% align=center><b>밋 션</b></td>
                                <td bgcolor=#FFFFFF colspan=2><span class=style5>&nbsp;A/T &nbsp;M/T &nbsp;SAT &nbsp;CVT</span></td>
                                <td bgcolor=#dddddd width=7% align=center><b>배기량</b></td>
                                <td bgcolor=#FFFFFF colspan=2 width=10% align=right><span class=style5><%=detail.getDpm()%>CC&nbsp;</span></td>
                                <td bgcolor=#dddddd width=8% align=center><b>도어수</b></td>
                                <td bgcolor=#FFFFFF align=right><span class=style5>DR&nbsp;</span></td>
                            </tr>
                            <tr>
                                <td bgcolor=#dddddd height=24 align=center><b>등록번호</b></td>
                                <td bgcolor=#FFFFFF width=24%>&nbsp;<b><%=detail.getCar_no()%></b></td>
                                <td bgcolor=#dddddd width=8% align=center><b>차대번호</b></td>
                                <td bgcolor=#FFFFFF colspan=6>&nbsp;<b><%=detail.getCar_num()%></b></td>
                                <td bgcolor=#dddddd align=center><b>승합<br>화물</b></td>
                                <td bgcolor=#FFFFFF align=right><span class=style5> 인승&nbsp;<br>TON&nbsp;</span></td>
                            </tr>
                            <tr>
                                <td bgcolor=#dddddd height=24 align=center><b>년 식</b></td>
                                <td bgcolor=#FFFFFF>&nbsp;<b><%=detail.getCar_y_form()%></b></td>
                                <td bgcolor=#dddddd rowspan=2 align=center><b>옵 션</b></td>
                                <td bgcolor=#FFFFFF rowspan=2 colspan=5>
                                    <table width=100% border=0 cellspacing=0 cellpadding=3>
                                        <tr><td><span class=style5>A/C &nbsp;P/S &nbsp;ADL &nbsp;CDP &nbsp;ABS &nbsp;가죽시트 &nbsp;썬루프 <br>
                                                알루미늄휠 &nbsp;에어백(싱글·듀얼) &nbsp;ECS &nbsp;AV <br>
                                                내비게이션(&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)</span></td>
                                        </tr>
                                    </table>
                                <td bgcolor=#dddddd width=6% align=center><b>연 료</b></td>
                                <td bgcolor=#FFFFFF colspan=2>
                                <span class=style5>&nbsp;&nbsp;
                                <%=c_db.getNameByIdCode("0039", "", detail.getFuel_kd())%>                                                            
                                </span></td>
                            </tr>
                            <tr>
                                <td bgcolor=#dddddd height=24 align=center><b>등록일</b></td>
                                <td bgcolor=#FFFFFF>&nbsp;<b><%=AddUtil.ChangeDate2(detail.getInit_reg_dt())%></b></td>
                                <td bgcolor=#dddddd align=center><b>색 상</b></td>
                                <td bgcolor=#FFFFFF colspan=2><span class=style5>&nbsp;<%=detail.getColo()%></span></td>
                            </tr>
                            <tr>
                                <td bgcolor=#dddddd height=24 align=center><b>주행거리</b></td>
                                <td bgcolor=#FFFFFF align=right><span class=style5>Km □ 불명&nbsp;</span></td>
                                <td bgcolor=#dddddd align=center><b>정기검사</b></td>
                                <td bgcolor=#FFFFFF colspan=2 width=15%><span class=style5>&nbsp;200 &nbsp;&nbsp;년 &nbsp;&nbsp;&nbsp;&nbsp;월 &nbsp;&nbsp;&nbsp;&nbsp;일</span></td>
                                <td bgcolor=#dddddd width=8% align=center><b>사용용도</b></td>
                                <td bgcolor=#FFFFFF colspan=3><span class=style5>자가 &nbsp;업무 &nbsp;사업 &nbsp;렌트</span></td>
                                <td bgcolor=#dddddd align=center><b>소유구분</b></td>
                                <td bgcolor=#FFFFFF><span class=style5>&nbsp;개인&nbsp;사업&nbsp;법인</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=7></td>
                </tr>
                <tr>
                    <td>
                        <table width=714 border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                            <tr>
                                <td width=39% bgcolor=#FFFFFF align=center valign=top height=140>
                                    <table width=95% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=2 height=22>&nbsp;<span class=style3>기능상태평가</span></td>
                                        </tr>
                                        <tr>
                                            <td height=20>·엔진본체 : (양호·불량)</td>
                                            <td>&nbsp;</td>
                                            <td>·현가장치 : (양호·불량)</td>
                                        </tr>
                                        <tr>
                                            <td height=20>·냉각장치 : (양호·불량)</td>
                                            <td>&nbsp;</td>
                                            <td>·조향장치 : (양호·불량)</td>
                                        </tr>
                                        <tr>
                                            <td height=20>·밋션장치 : (양호·불량)</td>
                                            <td>&nbsp;</td>
                                            <td>·에어컨,히터 : (양 · 불)</td>
                                        </tr>
                                        <tr>
                                            <td height=20>·제동장치 : (양호·불량)</td>
                                            <td>&nbsp;</td>
                                            <td>·연료장치 : (양호·불량)</td>
                                        </tr>
                                        <tr>
                                            <td height=20>·배기장치 : (양호·불량)</td>
                                            <td>&nbsp;</td>
                                            <td>·기타전장 : (양호·불량)</td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=12% bgcolor=#FFFFFF align=center valign=top height=140>
                                    <table width=100% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=22 align=center><span class=style3>사고유무평가</span></td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=49% bgcolor=#FFFFFF rowspan=2 align=center valign=top height=340> 
                                    <table width=95% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=22 colspan=2>&nbsp;<span class=style3>외관상태평가</span></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td rowspan=7><img src=/acar/images/content/cp_img.gif height=291></td>
                                            <td>
                                                <table width=81 border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td colspan=2 bgcolor=#dddddd align=center height=15>표시기호</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center width=55 height=15>도장필요</td>
                                                        <td bgcolor=#ffffff align=center>P</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>교환필요</td>
                                                        <td bgcolor=#ffffff align=center>X</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>휘 어 짐</td>
                                                        <td bgcolor=#ffffff align=center>U</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>상처있음</td>
                                                        <td bgcolor=#ffffff align=center>A</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>부 식 됨</td>
                                                        <td bgcolor=#ffffff align=center>C</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>균 열 됨</td>
                                                        <td bgcolor=#ffffff align=center>T</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>문자흔적</td>
                                                        <td bgcolor=#ffffff align=center>L</td>
                                                    </tr>
                                                </table>
                                            </td>    
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=81 border=0 cellspacing=1 Cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td bgcolor=#dddddd height=15 align=center>기본공구</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>쟈 키 (유·무)</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>휠렌치 (유·무)</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=3></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=81 border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td bgcolor=#dddddd height=15 align=center>실내상태</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>시 트 (양·불)</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>내 장 (양·불)</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=3></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=81 border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td bgcolor=#dddddd height=15 align=center>전체도장</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>유 · 무</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table> 
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor=#FFFFFF rowspan=2 align=center valign=top height=290>
                                    <table width=95% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=22>&nbsp;<span class=style3>특기사항(일반)</span></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td rowspan=2 bgcolor=#dddddd align=center>출품자<br>기록란</td>
                                                        <td colspan=2 bgcolor=#FFFFFF height=22 align=center>세금계산서 발행</td>
                                                        <td bgcolor=#FFFFFF align=center>可</td>
                                                        <td bgcolor=#FFFFFF align=center>不可</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=2 bgcolor=#FFFFFF height=22 align=center>차량탁송방법</td>
                                                        <td bgcolor=#FFFFFF align=center>탁송</td>
                                                        <td bgcolor=#FFFFFF align=center>본인</td>
                                                    </tr>
                                                    <tr>
                                                        <td rowspan=2 bgcolor=#dddddd align=center>경매장<br>사용란</td>
                                                        <td bgcolor=#FFFFFF height=22 align=center>엑셀입력</td>
                                                        <td bgcolor=#FFFFFF align=center>압류조회</td>
                                                        <td bgcolor=#FFFFFF align=center>출품접수</td>
                                                        <td bgcolor=#FFFFFF align=center>탁송신청</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#FFFFFF height=38 align=center>&nbsp;</td>
                                                        <td bgcolor=#FFFFFF align=center>&nbsp;</td>
                                                        <td bgcolor=#FFFFFF align=center>&nbsp;</td>
                                                        <td bgcolor=#FFFFFF align=center>&nbsp;</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;<span class=style3>지점 관련사항</span></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;·지역본부 :</td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;·지&nbsp;점&nbsp;명 :&nbsp;&nbsp;<%=detail.getP_car_off_nm()%></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;·카마스터 :&nbsp;&nbsp;<%=detail.getP_emp_nm()%></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;·사&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;번 :
                                            <!--
											<%// if ( detail.getP_emp_id().equals("011815")) {%>D000137
                                            <%//} else {%>D000328
                                            <%//} %>
											-->
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;·주민번호 :</td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;·신차계약번호 :&nbsp;&nbsp;<%=detail.getP_rpt_no()%></td>
                                        </tr>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                    </table>
                                </td>
                                <td bgcolor=#FFFFFF align=center height=190 valign=top>
                                    <table width=100% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td height=22 align=center><span class=style3>특기사항<br>(차량정보)</span></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor=#FFFFFF align=center height=90><span class=style3>메모란</span></td>
                                <td bgcolor=#FFFFFF>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=7></td>
                </tr>
                <tr>
                    <td>
                        <table width=714 border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                            <tr>
                                <td bgcolor=#FFFFFF align=center>
                                    <table width=100% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td width=48% align=center valign=top>
                                                <table width=96% border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=22>&nbsp;<span class=style3>출품자정보 (917)</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                                <tr>
                                                                    <td width=18% rowspan=2 align=center bgcolor=#dddddd>주민번호</td>
                                                                    <td bgcolor=#ffffff rowspan=2 align=center>115611 - 0019610</td>
                                                                    <td width=18% align=center bgcolor=#dddddd height=25>성명</td>
                                                                    <td bgcolor=#ffffff align=center>(주)아마존카</td>
                                                                </tr>
                                                                <tr>
                                                                    <td align=center bgcolor=#dddddd height=25>전화번호</td>
                                                                    <td bgcolor=#ffffff align=center>02-392-4243</td>
                                                                </tr>
                                                                <tr>
                                                                    <td align=center bgcolor=#dddddd height=32>주 소</td>
                                                                    <td bgcolor=#ffffff colspan=3>&nbsp;서울시 영등포구 여의도동 17-3 삼환까뮤 802호</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                                                                <tr>
                                                                    <td width=58 align=center bgcolor=#dddddd><font color=c00000><b>희망가</b></font></td>
                                                                    <td bgcolor=#ffffff height=30 align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff width=9% align=center><b>,</b></td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff width=12% align=center>만원</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                                                                <tr>
                                                                    <td width=58 align=center bgcolor=#dddddd><font color=c00000><b>시작가</b></font></td>
                                                                    <td bgcolor=#ffffff height=30 align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff width=9% align=center><b>,</b></td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff width=12% align=center>만원</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                                <tr>
                                                                    <td width=58 align=center bgcolor=#dddddd>입 금<br>계 좌</td>
                                                                    <td bgcolor=#ffffff height=60 align=center>
                                                                        <table width=95% border=0 cellspacing=0 cellpadding=0>
                                                                            <tr>
                                                                                <td height=25>예금주 ( 아마존카 )  &nbsp;&nbsp;거래은행 ( 신한 )</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=25>계좌번호 ( 140 - 004 - 023871 )</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                                <tr>
                                                                    <td width=58 align=center bgcolor=#ffffff>고&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;객<br>확인서명</td>
                                                                    <td bgcolor=#ffffff>
                                                                        <table width=100% border=0 cellpadding=3 cellspacing=0>
                                                                            <tr>
                                                                                <td valign=top height=44 align=center><font style="font-size:5pt">상기내용이 틀림없음을 확인하며 주의사항에 동의하여 서명합니다.</font></td>
                                                                                <td align=right align=right><b>(인)</b></td>
                                                                             </tr>
                                                                         </table>
                                                                     </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align=center bgcolor=#ffffff>평 가 사<br>확인서명</td>
                                                                    <td bgcolor=#ffffff>
                                                                        <table width=100% border=0 cellpadding=3 cellspacing=0>
                                                                            <tr>
                                                                                <td valign=top  height=44 align=center valign=top><font style="font-size:5pt">상기내용이 틀림없음을 확인하며 주의사항에 동의하여 서명합니다.</font></td>
                                                                                <td align=right><b>(인)</b></td>
                                                                             </tr>
                                                                         </table>
                                                                     </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=52%>
                                                <table width=99% border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=6></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=22 style="font-size:11px">&nbsp;<font color=c00000><b>※ 기입요령 및 주의사항</b></font></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; · 차명은 차량 세부명칭까지 반드시 명기하십시오.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 예) 세피아 1.5 RS</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; · 주행거리는 단단위까지 기입하십시오.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp;<b> · 외관상태는 해당 부위에 직접 표시하고 수리이력이 있을시에는<br>&nbsp;&nbsp;&nbsp;&nbsp;  외부에 표시하십시오.</b></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; · 사고유무란에는 사고부위, 사고내용, 수리부위, 개조내용 등을 상세히<br>&nbsp;&nbsp;&nbsp;&nbsp;  기입하십시오.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; · 각 항목의 기재사항이 허위나 오기입시 그에 따른 민·형사의 책임은<br>&nbsp;&nbsp;&nbsp;&nbsp; 출품자가 지게 되니 유의하시기 바랍니다.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; · 인수자로부터 중대한 클레임(이의)이 제기될 경우 출품고객께서는<br>&nbsp;&nbsp;&nbsp;&nbsp; 당사와 처리해야 할 의무가 있습니다.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; · </b>낙찰시 탁송료는 낙찰대금에서 공제하며, 유찰시 경매장 입고 및 고객<br>&nbsp;&nbsp;&nbsp;&nbsp; 반출 탁송료는 고객 부담임을 주지하시기 바랍니다.</b></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=13></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=99% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                                <tr>
                                                                    <td align=center bgcolor=#dddddd colspan=2 height=18><span class=style5>※ 구비서류 ( 구비된 서류에 V표시 바랍니다 )</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td align=center bgcolor=#FFFFFF height=18><span class=style5>개인/개인사업자</span></td>
                                                                    <td align=center bgcolor=#FFFFFF><span class=style5>법인사업자</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td bgcolor=#ffffff align=center width=49% valign=top>
                                                                        <table width=95% border=0 cellpadding=0 cellspacing=0>
                                                                            <tr>
                                                                                <td height=5></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">□ 자동차등록증 원본</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">□ 인감증명서 1통</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">□ 자동차양도행위 위임장(인감날인)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">□ 자동차세(지방세) 납세증명서</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">□ 자동차세 일할계산신청서(인감<날인)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">□ 사업자등록증 사본 1부(개인사업자)</font></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td bgcolor=#ffffff align=center width=51%>
                                                                        <table width=95% border=0 cellpadding=0 cellspacing=0>
                                                                            <tr>
                                                                                <td height=5></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">□ 자동차등록증 원본</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">□ 법인 인감증명서/등기부등본 각1부</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">□ 자동차양도행위 위임장(인감날인)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">□ 자동차세(지방세) 납세증명서</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">□ 자동차세 일할계산신청서(인감날인)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">□ 사업자등록증명원 (단, 사용본거지와<br>&nbsp;&nbsp;&nbsp; 소유주의 주소가 상이할 경우만 제출)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=3></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=7></td>
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
                    <td align=center>
                        <table width=97% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=24 width=20%><img src=/acar/images/content/glovis.gif align=absmiddle></td>
                                <td><b>현대·기아자동차경매장</td>
                                <td align=right><b>문의전화 :</b> 031-760-5300, 5354, 5350&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>FAX :</b> 031-760-5390</td>
                            </tr>
                        </table>
                    </td>
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


