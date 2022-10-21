<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_sui.*"%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	Offls_suiBean detail = olsD.getSui_detail(car_mng_id);
	String imgfile[] = new String[5];
	imgfile[0] = detail.getImgfile1();
	imgfile[1] = detail.getImgfile2();
	imgfile[2] = detail.getImgfile3();
	imgfile[3] = detail.getImgfile4();
	imgfile[4] = detail.getImgfile5();
	

	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();

	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//상품평가 수정 등록 구분하기 위해
	String apprsl_car_mng_id = olsD.getApprsl_Car_mng_id(car_mng_id);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<style>
a:link { text-decoration:none; }
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
var imgnum =0;
carImage = new Array();
for(i=0; i<5; i++){
	carImage[i] = new Image();
}
carImage[0].src = "https://fms3.amazoncar.co.kr/images/carImg/<%=imgfile[0]%>.gif";
carImage[1].src = "https://fms3.amazoncar.co.kr/images/carImg/<%=imgfile[1]%>.gif";
carImage[2].src = "https://fms3.amazoncar.co.kr/images/carImg/<%=imgfile[2]%>.gif";
carImage[3].src = "https://fms3.amazoncar.co.kr/images/carImg/<%=imgfile[3]%>.gif";
carImage[4].src = "https://fms3.amazoncar.co.kr/images/carImg/<%=imgfile[4]%>.gif";

function show(n){
	document.images["carImg"].src = carImage[n].src;
	document.form1.carImg.value = carImage[n].src;
	imgnum = n;
}
function ChDate(arg)
{
	var ch_date = replaceString("-","",arg);

	if(ch_date!="")
	{
	if(ch_date.length!=8)
	{
		alert('날짜의 형식은 "2002-01-23" 또는 "200020123" 입니다.');
		return "";
	}
	ch_year = parseInt(ch_date.substring(0,4),10);
	ch_month = parseInt(ch_date.substring(4,6),10);
	ch_day = parseInt(ch_date.substring(6,8),10);
	if(isNaN(ch_date))
	{
		alert("숫자와 '-' 만이 입력가능합니다.");
		return "";
	}
	if(!(ch_month>0 && ch_month<13))
	{
		alert("월은 01 - 12 까지만 입력 가능합니다.");
		return "";
	}
	ck_day = getDaysInMonth(ch_year,ChangeNum(ch_month))
	if(ck_day<ch_day)
	{
		alert("일은 01 - " + ck_day + " 까지만 입력 가능합니다.");
		return "";
	}
		
	return ch_year + ""+ChangeNum(ch_month) + ChangeNum(ch_day);
	}else{
	return "";
	}
}
function apprslUpd(ioru)
{
	var fm = document.form1;	
	var apprsl_dt = ChDate(fm.apprsl_dt.value);
	if(apprsl_dt != ""){
		fm.apprsl_dt_s.value = apprsl_dt;
	}else{
		alert("평가일자를 입력하세요!");
		return;
	}
	if(ioru=="i"){
		if(!confirm('평가내용을 등록하시겠습니까?')){ return; }
	}else if(ioru=="u"){
		if(!confirm('평가내용을 수정하시겠습니까?')){ return; }
	}
	fm.gubun.value = ioru;
	fm.action="/acar/off_lease/off_lease_apprsl_upd.jsp";
	fm.target = "i_no";
	fm.submit();
}
function open_car_mng()
{
	var url = "?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
	var SUBWIN = "/acar/off_lease/off_lease_car_mng.jsp"+url;
	window.open(SUBWIN, "View_CAR_MNG", "left=70, top=80, width=735, height=400, resizable=yes, scrollbars=yes");
}
function open_car_his()
{
	var url = "?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
	var SUBWIN = "/acar/off_lease/off_lease_car_his.jsp"+url;
	window.open(SUBWIN, "View_CAR_HIS", "left=70, top=80, width=550, height=400, resizable=yes, scrollbars=yes");
}
function open_accident()
{
	var url = "?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&car_no=<%=detail.getCar_no()%>&car_nm=<%=detail.getCar_nm()%>";
	var SUBWIN = "/acar/off_lease/off_lease_accident.jsp"+url;
	window.open(SUBWIN, "View_ACCIDENT", "left=70, top=80, width=835, height=400, resizable=yes, scrollbars=yes");
}
function imgAppend(){
	<%
	int num = 0;
	for(int i=0; i<imgfile.length; i++){
		if(!imgfile[i].equals("")){
			num++;
		}
	}
	if(num==5){%>
		alert("5개까지만 추가됩니다.!");
		return;
	<%}else{%>
		window.open("/acar/off_lease/off_lease_imgAppend.jsp?car_mng_id=<%=car_mng_id%>&imgfile1=<%=detail.getImgfile1()%>&imgfile2=<%=detail.getImgfile2()%>&imgfile3=<%=detail.getImgfile3()%>&imgfile4=<%=detail.getImgfile4()%>&imgfile5=<%=detail.getImgfile5()%>&imgnum=<%= num %>", "imgAppend", "left=300, top=200, width=400, height=100, resizable=no, scorllbars=no");
	<%}%>
}
function imgDelete(){
	var imgName = "";
	if(imgnum==0){ imgName = "앞측"; }
	else if(imgnum==1){ imgName = "실내"; }
	else if(imgnum==2){ imgName = "뒤"; }
	else if(imgnum==3){ imgName = "뒷측"; }
	else if(imgnum==4){ imgName = "앞";}

	if(!confirm(imgName+' 이미지를 삭제하시겠습니까?')){ return; }
	var fm = document.form1;
	fm.action = "/acar/off_lease/off_lease_imgDelete.jsp";
	fm.target = "i_no";
	fm.imgnum.value = imgnum;
	fm.submit();
}
function imgBig(){
	var imgName = document.form1.carImg.value;
	window.open("/acar/off_lease/off_lease_imgBig.jsp?car_mng_id=<%=car_mng_id%>&imgName="+imgName,"imgBig", "left=200, top=100, width=620, height=420, resizable=no, scorllbars=no");
}
-->
</script>
</head>
<body>
<form name="form1" action="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="imgnum" value="">
<input type="hidden" name="apprsl_dt_s" value="">
<input type="hidden" name="gubun" value="">
  <table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr> 
      <td align='left' colspan="2"> <<기본정보>> </td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding='0' >
          <tr> 
            <td class='title' width='120'>차량연번</td>
            <td class='title' width="130">차량번호</td>
            <td class='title' width="150">최초등록일</td>
            <td class='title' width="150">출고일</td>
            <td class='title' width="250">차대번호</td>
          </tr>
          <tr> 
            <td align="center" width="120"><%=detail.getCar_l_cd()%></td>
            <td align="center" width="130"><%=detail.getCar_no()%></td>
            <td align="center" width="150"><%=AddUtil.ChangeDate2(detail.getInit_reg_dt())%></td>
            <td align="center" width="150"><%=AddUtil.ChangeDate2(detail.getDlv_dt())%></td>
            <td align="center" width="250"><%=detail.getCar_num()%></td>
          </tr>
          <tr> 
            <td class='title' width="120">용도</td>
            <td class='title' width="130">연료</td>
            <td class='title' width="150">배기량</td>
            <td class='title' width="150">연식</td>
            <td class='title' width="250">형식</td>
          </tr>
          <tr> 
            <td align="center" width="120"> 
              <%if(detail.getCar_use().equals("1")){%>
              영업용 
              <%}else{%>
              자가용 
              <%}%>
            </td>
            <td align="center" width="130"><%=c_db.getNameByIdCode("0039", "", detail.getFuel_kd())%></td>
            <td align="center" width="150"><%=detail.getDpm()%> cc</td>
            <td align="center" width="150"><%=detail.getCar_y_form()%></td>
            <td align="center" width="250"><%=detail.getCar_form()%> </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td align='left' colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td align='left' colspan="2"> <<차량가격>> </td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding='0' width="800" >
          <tr> 
            <td rowspan="6"  width="130" align="center"> <img src="<%if(!imgfile[0].equals("")){%>	
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile1()%>.gif
						<%}else if(!detail.getImgfile2().equals("")){%>
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile2()%>.gif
						<%}else if(!detail.getImgfile3().equals("")){%>
					        https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile3()%>.gif
						<%}else if(!detail.getImgfile4().equals("")){%>
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile4()%>.gif
						<%}else if(!detail.getImgfile5().equals("")){%>
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile5()%>.gif
						<%}else{}%>" 
						name="carImg" 
						value = "<%if(!imgfile[0].equals("")){%>	
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile1()%>.gif
						<%}else if(!detail.getImgfile2().equals("")){%>
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile2()%>.gif
						<%}else if(!detail.getImgfile3().equals("")){%>
					        https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile3()%>.gif
						<%}else if(!detail.getImgfile4().equals("")){%>
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile4()%>.gif
						<%}else if(!detail.getImgfile5().equals("")){%>
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile5()%>.gif
						<%}else{}%>" 
						border="0" width="120" height="120" onclick="javascript:imgBig()"></td>
            <td rowspan="2"  class='title' width="50">구분</td>
            <td class='title' rowspan="2" width="120">명칭</td>
            <td class="title" colspan="3">소비자가</td>
            <td class="title" colspan="3">구입가</td>
          </tr>
          <tr> 
            <td  class='title' width="80">공급가</td>
            <td  class='title' width="80">부가세</td>
            <td  class='title' width="90">합계</td>
            <td  class='title' width="80">공급가</td>
            <td  class='title' width="80">부가세</td>
            <td  class='title' width="90">합계</td>
          </tr>
          <tr> 
            <td width="50" align="center" >차명</td>
            <td align="center" width="120" ><span title='<%=detail.getCar_nm()%>'><%=AddUtil.subData(detail.getCar_nm(),8)%></span></td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getCar_cs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getCar_cv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getCar_cs_amt()+detail.getCar_cv_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getCar_fs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getCar_fv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getCar_fs_amt()+detail.getCar_fv_amt())%>&nbsp;</td>
          </tr>
          <tr> 
            <td width="50" align="center" >옵션</td>
            <td align="center" width="120" ><span title='<%=detail.getOpt()%>'><%=AddUtil.subData(detail.getOpt(),8)%></span></td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getOpt_cs_amt())%>&nbsp;</td>
            <td align="right" width="80"><%=AddUtil.parseDecimal(detail.getOpt_cv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getOpt_cs_amt()+detail.getOpt_cv_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getOpt_fs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getOpt_fv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getOpt_fs_amt()+detail.getOpt_fv_amt())%>&nbsp;</td>
          </tr>
          <tr> 
            <td width="50" align="center" >색상</td>
            <td align="center" width="120" ><span title='<%=detail.getColo()%>'><%=AddUtil.subData(detail.getColo(),8)%></span></td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getClr_cs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getClr_cv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getClr_cs_amt()+detail.getClr_cv_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getClr_fs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getClr_fv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getClr_fs_amt()+detail.getClr_fv_amt())%>&nbsp;</td>
          </tr>
          <tr> 
            <td colspan="2" align="center">매출DC</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getDc_cs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getDc_cv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getDc_cs_amt()+detail.getDc_cv_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getDc_fs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getDc_fv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getDc_fs_amt()+detail.getDc_fv_amt())%>&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"> 
              <%
			int j=1;
			for(int i=0; i<imgfile.length; i++){
				if(!imgfile[i].equals("")){%>
              <a href="#" onClick="show(<%=i%>)">
              <%if(j==1){%>
              앞측 
              <%}else if(j==2){%>
              실내 
              <%}else if(j==3){%>
              뒤 
              <%}else if(j==4){%>
              뒷측 
              <%}else if(j==5){%>
              앞 
              <%}%>
              </a> 
              <%}
				j++;
			}
			for(int i=0; i<imgfile.length; i++){
				if(!imgfile[i].equals("")){%>
              <script language="javascript">
						imgnum = <%=i%>;
						//alert(imgnum);
					</script> 
              <%break;
				}
			}
			if(imgfile[0].equals("") && imgfile[1].equals("") && imgfile[2].equals("") && imgfile[3].equals("") && imgfile[4].equals("")){%>
              이미지없음 
              <%}%>
            </td>
            <td colspan="2" align="center">탁송료</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getSd_cs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getSd_cv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getSd_cs_amt()+detail.getSd_cv_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getSd_fs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getSd_fv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getSd_fs_amt()+detail.getSd_fv_amt())%>&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"> 
              <%if(auth_rw.equals("4")||auth_rw.equals("6")){
				if(imgfile[0].equals("") && imgfile[1].equals("") && imgfile[2].equals("") && imgfile[3].equals("") && imgfile[4].equals("")){%>
              <a href='javascript:imgAppend();' onMouseOver="window.status=''; return true"> 
              <img src="/images/add.gif" width="50" height="18" align="absmiddle" border="0" alt="추가"></a> 
              <%}else{%>
              <a href='javascript:imgAppend();' onMouseOver="window.status=''; return true"> 
              <img src="/images/add.gif" width="50" height="18" align="absmiddle" border="0" alt="추가"></a> 
              &nbsp;&nbsp;<a href='javascript:imgDelete();' onMouseOver="window.status=''; return true"> 
              <img src="/images/del.gif" width="50" height="18" align="absmiddle" border="0" alt="삭제"></a> 
              <%}
			 }%>
            </td>
            <td colspan="2" align="center">합 계</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getCar_cs_amt()+detail.getOpt_cs_amt()+detail.getClr_cs_amt()+detail.getSd_cs_amt()+detail.getDc_cs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getCar_cv_amt()+detail.getOpt_cv_amt()+detail.getClr_cv_amt()+detail.getSd_cv_amt()+detail.getDc_cv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><b><%=AddUtil.parseDecimal(detail.getCar_cs_amt()+detail.getOpt_cs_amt()+detail.getClr_cs_amt()+detail.getSd_cs_amt()+detail.getDc_cs_amt()+detail.getCar_cv_amt()+detail.getOpt_cv_amt()+detail.getClr_cv_amt()+detail.getSd_cv_amt()+detail.getDc_cv_amt())%></b>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getCar_fs_amt()+detail.getOpt_fs_amt()+detail.getClr_fs_amt()+detail.getSd_fs_amt()+detail.getDc_fs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getCar_fv_amt()+detail.getOpt_fv_amt()+detail.getClr_fv_amt()+detail.getSd_fv_amt()+detail.getDc_fv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><b><%=AddUtil.parseDecimal(detail.getCar_fs_amt()+detail.getOpt_fs_amt()+detail.getClr_fs_amt()+detail.getSd_fs_amt()+detail.getDc_fs_amt()+detail.getCar_fv_amt()+detail.getOpt_fv_amt()+detail.getClr_fv_amt()+detail.getSd_fv_amt()+detail.getDc_fv_amt())%></b>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td align='left' colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td align='left' colspan="2"> <<기타정보>></td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class='title' width='120'> 할부금융사</td>
            <td align='center' width="180"> 
              <%if(detail.getBank_nm().equals("")){%>
              - 
              <%}else{%>
              <%=detail.getBank_nm()%> 
              <%}%>
            </td>
            <td class='title' width='100'> 대출금액</td>
            <td align='center' width='150'><%=AddUtil.parseDecimal(detail.getLend_prn())%>&nbsp;원</td>
            <td class='title' width='100'>상환원금잔액</td>
            <td align='center' width='150'><%=AddUtil.parseDecimal(detail.getLend_rem())%>&nbsp;원</td>
          </tr>
          <tr> 
            <td class='title' width='120'> 보험사</td>
            <td align='center' width="180"><%= detail.getIns_com_nm() %></td>
            <td class='title' width='100'> 보험유효기간</td>
            <td align='center' width='150'><%= AddUtil.ChangeDate2(detail.getIns_exp_dt()) %></td>
            <td class='title' >상환만료일</td>
            <td align="center" width='150'><%=AddUtil.ChangeDate2(detail.getAlt_end_dt())%></td>
          </tr>
          <tr> 
            <td class='title' width="120">정기검사유효기간</td>
            <td align='center' width="180"><%=AddUtil.ChangeDate2(detail.getMaint_st_dt())%> 
              ~ <%=AddUtil.ChangeDate2(detail.getMaint_end_dt())%></td>
            <td class='title' width="100"> 누적주행거리</td>
            <td align="center" width='150'><%=AddUtil.parseDecimal(detail.getToday_dist())%> 
              km</td>
            <td class="title" width="100" align="center">평균주행거리</td>
            <td align="center" ><%=AddUtil.parseDecimal(detail.getAverage_dist())%> 
              km</td>
          </tr>
          <tr> 
            <td class='title' width="120">점검유효기간</td>
            <td align='center' width="180"><%=AddUtil.ChangeDate2(detail.getTest_st_dt())%> 
              ~ <%=AddUtil.ChangeDate2(detail.getTest_end_dt())%></td>
            <td class='title' width="100">구조변경</td>
            <td align="center" width='150'> 
              <%if(detail.getCar_cha_yn().equals("1")){%>
              &nbsp;있음 
              <%}else{%>
              &nbsp;없음 
              <%}%>
            </td>
            <td class="title" width="100" align="center">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td align='left' colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td align='left'><<상품평가>></td>
      <td align="right"> 
        <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
        <%if(apprsl_car_mng_id.equals("")){%>
        <a href='javascript:apprslUpd("i");' onMouseOver="window.status=''; return true"> 
        <img src="/images/reg.gif" width="50" height="18" align="absmiddle" border="0" alt="등록"></a> 
        <%}else{%>
        <a href='javascript:apprslUpd("u");' onMouseOver="window.status=''; return true"> 
        <img src="/images/update.gif" width="50" height="18" align="absmiddle" border="0" alt="수정"></a> 
        <%}%>
        <%}%>
      </td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" >
          <tr> 
            <td class='title' width='120'> 자체평가</td>
            <td width='180'>&nbsp; 
              <select name='apprsl_lev'>
                <option value='0'>선택</option>
                <option value='1' <%if(detail.getLev().equals("1")){%>selected<%}%>>상</option>
                <option value='2' <%if(detail.getLev().equals("2")){%>selected<%}%>>중</option>
                <option value='3' <%if(detail.getLev().equals("3")){%>selected<%}%>>하</option>
              </select>
            </td>
            <td class='title' width='100'>평가일자</td>
            <td align="center" width='150' > 
              <input  class="text" type="text" name="apprsl_dt" size="20" value="<%=AddUtil.ChangeDate2(detail.getApprsl_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
            </td>
            <td class='title' width='100'>&nbsp;</td>
            <td width='150'>&nbsp; </td>
          </tr>
          <tr> 
            <td class='title' width="120">평가요인</td>
            <td colspan="5">&nbsp; 
              <textarea  class="textarea" name="apprsl_reason" cols="70" rows="2"><%=detail.getReason()%></textarea>
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">차량상태</td>
            <td colspan="5">&nbsp; 
              <input  class="text" type="text" name="apprsl_car_st" size="70" value="<%=detail.getCar_st()%>">
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">사고유무</td>
            <td width="180"> &nbsp; 
              <%if(detail.getAccident_yn().equals("1")){%>
              &nbsp;있음 
              <%}else{%>
              &nbsp;없음 
              <%}%>
            </td>
            <td width="100" class='title'>담당자</td>
            <td width="150">&nbsp; 
              <select name="damdang_id">
                <option value='' <%if(detail.getDamdang_id().equals("")){%>selected<%}%>>선택</option>
                <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	
%>
                <option value='<%=user.get("USER_ID")%>' <%if(detail.getDamdang_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                <%
						}
					}		%>
              </select>
            </td>
            <td width="100" class='title'>최종수정자</td>
            <td width="150">&nbsp; 
              <%if(login.getAcarName(detail.getModify_id()).equals("error")){%>
              &nbsp; 
              <%}else{%>
              <%=login.getAcarName(detail.getModify_id())%> 
              <%}%>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>