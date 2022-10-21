<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_actn.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.car_register.*,acar.car_mst.*, acar.offls_pre.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_actn.Offls_actnBean"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>

<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="CarKeyBn" scope="page" class="acar.car_register.CarKeyBean"/>
<jsp:useBean id="CarMngDb" scope="page" class="acar.car_register.CarMngDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>

<jsp:useBean id="olyBean" class="acar.offls_pre.Offls_preBean" scope="page"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	String st = request.getParameter("st")==null?"3":request.getParameter("st");
	String gubun = request.getParameter("gubun")==null?"firm_nm":request.getParameter("gubun");	
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");	
	String q_sort_nm = request.getParameter("q_sort_nm")==null?"firm_nm":request.getParameter("q_sort_nm");	
	String q_sort = request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"00000000":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"99999999":request.getParameter("ref_dt2");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rpt_no = request.getParameter("rpt_no")==null?"":request.getParameter("rpt_no");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String client_nm = request.getParameter("client_nm")==null?"":request.getParameter("client_nm");
	String car_name = request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String cmd = "jh";
	String[] pre = request.getParameterValues("pr");
	int imm_amt = request.getParameter("imm_amt")==null?0:Util.parseInt(request.getParameter("imm_amt"));
	


%>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>일괄출력</title>
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
<%
		for(int i=0; i<pre.length; i++){
		pre[i] = pre[i].substring(0,6);
		car_mng_id = pre[i];
		Hashtable cont = a_db.getContViewUseYCarCase(car_mng_id);
		rent_mng_id 	= String.valueOf(cont.get("RENT_MNG_ID"));
		rent_l_cd 	= String.valueOf(cont.get("RENT_L_CD"));
	detail = olaD.getActn_detail(car_mng_id);
	int a=1000;
	//차량정보
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	//자동차회사&차종&자동차명
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(rent_mng_id, rent_l_cd);
	//차량번호 이력
	CarHisBean ch_r [] = crd.getCarHisAll(car_mng_id);
	String white = "white";	
	CarKeyBn = CarMngDb.getCarKey(car_mng_id);
	//차량정보
	Off_ls_pre_apprsl ap_bean = rs_db.getCarBinImg2(car_mng_id);
	//차량정보
	Hashtable res = rs_db.getCarInfo(car_mng_id);
	
	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	Offls_preBean olyb[] = olpD.getPre_lst(gubun, gubun_nm, brch_id);
	int totCsum = 0;
	int totFsum = 0;
	String actn_cnt = ""; //반출시 경매회차
	String actn_id = olpD.getActn_id(car_mng_id);
	if(cmd.equals("")){
		olyBean = olpD.getPre_detail(car_mng_id); //매각결정차량현황에서 보증서 출력시
	}else{
		olyBean = olpD.getPre_detail2(car_mng_id); //출품현황에서 보증서 출력시
	}
	String car_no = olyBean.getCar_no();
	
	seq = olaD.getAuctionPur_maxSeq(car_mng_id);
%>		
<!-- 양도행위위임장 -->
<form action="" name="form1" method="POST" >
<table  width=100% border=0 height= border=0 cellpadding=0 cellspacing=0 align=center >
	<tr>
      <td colspan="5" align="center" height=40></td>
    </tr>
	<tr>
		<td align=center><font size='2'>(이 위임장은 차량관리법 제49조에 의거 중고자동차 매매업의 허가를 받은자 이외의 자는 사용할 수 없다.)</font></td>
    </tr>
</table>
<table width=100% border=1 height=90% border=0 cellpadding=0 cellspacing=0 >
    <tr>
      <td colspan="5" align="center" height=60><font size='10'><b>자동차양도행위위임장</b></font></td>
    </tr>
    <tr>
      <td colspan="1" rowspan="4" align="center" width="10%" style="font-family:dodtum; font-size:16px !important;">자동차의<br>표&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;시</td>
      <td align="center" width="15%"  height=40 style="font-family:dodtum; font-size:16px !important;">자동차등록번호</td>
      <td colspan="3" rowspan="1" style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=cr_bean.getCar_no()%></td>
    </tr>
    <tr>
      <td align="center" width="15%" height=40 style="font-family:dodtum; font-size:16px !important;">차&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;종</td>
      <td width="30%" style="font-family:dodtum; font-size:16px !important;">&nbsp;
	  <%=c_db.getNameByIdCode("0041", "", cr_bean.getCar_kd())%>	 
	  </td>
      <td align="center" width="15%" height=40 style="font-family:dodtum; font-size:16px !important;">차&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td>
      <td width="30%" style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=mst.getCar_nm()%> <%//=mst.getCar_name()%> </td>
    </tr>
    <tr>
      <td align="center" height=30 height=40 style="font-family:dodtum; font-size:16px !important;">차&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;대&nbsp;&nbsp;&nbsp;번&nbsp;&nbsp;&nbsp;호</td>
      <td style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=cr_bean.getCar_num()%></td>
      <td align="center" height=30 height=40 style="font-family:dodtum; font-size:16px !important;">원동기형식</td>
      <td style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=cr_bean.getCar_form()%></td>
    </tr>
    <tr>
      <td align="center" height=40 style="font-family:dodtum; font-size:16px !important;">연&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;식</td>
      <td style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=cr_bean.getCar_y_form()%></td>
      <td align="center" height=40 style="font-family:dodtum; font-size:16px !important;">배&nbsp;&nbsp;&nbsp;기&nbsp;&nbsp;&nbsp;량</td>
      <td style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=cr_bean.getDpm()%> cc</td>
    </tr>
    <tr>
      <td colspan="5" style="font-family:dodtum; font-size:16px !important;">
	  <p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;피위임자<p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소&nbsp;&nbsp;&nbsp;재&nbsp;&nbsp;&nbsp;지 :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;매매업허가번호 :<p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;호 :<p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;대표자성명 :<p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;본인이 귀사에 상기 차량매도를 위탁한에 있어 귀사가 본인을 대위하여<p><p>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;매매계약 체결·양도증명서 교부·수출등록말소 등 매수인에게 소유권 <p><p>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이전을 위한 일체의 행위를 할 권한과 양도증명서 및 계약서에 귀사의<p><p>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;직인을 날인하여 권한 행위를 하여 줄 것을 위임하며, 본인이 귀사에 <p><p>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;교부한 인감증명(자동차매매용)상의 인감으로 이를 증명함.<p><p><br>
	  
	  <center><%=AddUtil.getDate().substring(0,4)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.<p><p><br>
	  위임자(매도인)&nbsp;&nbsp;&nbsp;&nbsp;성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명 :&nbsp;주식회사 아마존카&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)</center><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소 :&nbsp;서울특별시  영등포구 의사당대로 8, 802 (여의도동, 태흥빌딩)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;주민등록번호 :&nbsp;115611-0019610&nbsp;&nbsp;<p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;귀&nbsp;&nbsp;&nbsp;하<p>
	  </td>
    </tr>
</table>
    
<table>
	<tr>
		<td style="font-family:dodtum; font-size:16px !important;">교통부승인 1990.  8.  27<br>차량 33150 - 9277</td>
    </tr>
</table>
</form>
<!-- 양도행위위임장끝 -->

<!-- 출품신청서 -->
<form name='form2' method='post' action=''>
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
<!--출품신청서 끝-->
<!-- 품질보증서 -->

<form name='form3' method='post' action=''>

<div>
<table width=754 border=0 cellpadding=18 cellspacing=1 bgcolor=5B608C>
    <tr>
        <td bgcolor=#FFFFFF valign=top align=center>
            <table width=708 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=20% align=center><img src=/acar/images/content/logos.gif width=92 height=25></td>
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
                                                        환불받는
획기적인 거래조건입니다. 이는 당사가 업계 최초로 개발 시행하였으며,당<br>
                                                        사 전 출품차량에 권리를 제공합니다. 당사가 출품하는 모든 자동차에 제공하는 품<br>
                                                        질보증서 및 재구입 보증서는 혹시 있을 고객님의 손실을 최소화하고, 수익의 극대<br>화를 보증해주는 당사 차량만
이 갖는 슈퍼프리미엄서비스입니다.<br><font color=999999>(시행일자:2008년 04월 25일)</font></td>
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
<!-- 품질보증서 끝 -->
<div style="page-break-after: always"></div>
<%}%>
</body>
</html>

<script>
onprint();

function onprint(){
	
	var userAgent = navigator.userAgent.toLowerCase();
	if (userAgent.indexOf("edge") > -1) {
		window.print();
	} else if (userAgent.indexOf("whale") > -1) {
		window.print();
	} else if (userAgent.indexOf("chrome") > -1) {
		window.print();
	} else if (userAgent.indexOf("firefox") > -1) {
		window.print();
	} else if (userAgent.indexOf("safari") > -1) {
		window.print();
	} else {
		IE_Print();
	}
}	

function IE_Print() {
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

