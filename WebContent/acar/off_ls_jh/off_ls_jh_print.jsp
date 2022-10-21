<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.car_register.*,acar.car_mst.*, acar.offls_pre.*"%>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="CarKeyBn" scope="page" class="acar.car_register.CarKeyBean"/>
<jsp:useBean id="CarMngDb" scope="page" class="acar.car_register.CarMngDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String st = request.getParameter("st")==null?"3":request.getParameter("st");
	String gubun = request.getParameter("gubun")==null?"firm_nm":request.getParameter("gubun");	
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");	
	String q_sort_nm = request.getParameter("q_sort_nm")==null?"firm_nm":request.getParameter("q_sort_nm");	
	String q_sort = request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"00000000":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"99999999":request.getParameter("ref_dt2");
%>

<%
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rpt_no = request.getParameter("rpt_no")==null?"":request.getParameter("rpt_no");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String client_nm = request.getParameter("client_nm")==null?"":request.getParameter("client_nm");
	String car_name = request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int imm_amt = request.getParameter("imm_amt")==null?0:Util.parseInt(request.getParameter("imm_amt"));
	
	if(rent_l_cd.equals("")){
		Hashtable cont = a_db.getContViewUseYCarCase(car_mng_id);
		rent_mng_id 	= String.valueOf(cont.get("RENT_MNG_ID"));
		rent_l_cd 	= String.valueOf(cont.get("RENT_L_CD"));
	}
	
	//차량정보
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
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
%>
	
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>

</head>
<body leftmargin="15" topmargin="1"  >
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 


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
	  위임자(매도인) 성명 :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)</center><p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;주소 :<p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;주민등록번호 :<p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	  귀&nbsp;&nbsp;&nbsp;하<p>
	  </td>
    </tr>
</table>
    
<table>
	<tr>
		<td style="font-family:dodtum; font-size:16px !important;">교통부승인 1990.  8.  27<br>차량 33150 - 9277</td>
    </tr>
</table>
</form>

</body>
</html>

<script>

onprint();

//5초후에 인쇄박스 팝업
//setTimeout(onprint_box,5000);


function onprint(){
	factory.printing.header 	= ""; //폐이지상단 인쇄
	factory.printing.footer 	= ""; //폐이지하단 인쇄
	factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
	factory.printing.leftMargin 	= 10.0; //좌측여백   
	factory.printing.rightMargin 	= 10.0; //우측여백
	factory.printing.topMargin 	= 10.0; //상단여백    
	factory.printing.bottomMargin 	= 10.0; //하단여백
}
function onprint_box(){
	factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}

</script>
