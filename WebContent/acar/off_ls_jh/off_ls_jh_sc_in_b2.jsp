<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<%@ page import="acar.offls_actn.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_actn.Offls_actnBean"/>
<jsp:useBean id="apprsl" scope="page" class="acar.offls_pre.Off_ls_pre_apprsl"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="olyD" class="acar.offls_yb.Offls_ybDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	detail = olaD.getActn_detail(car_mng_id);
	String imgfile[] = new String[5];
	imgfile[0] = detail.getImgfile1();
	imgfile[1] = detail.getImgfile2();
	imgfile[2] = detail.getImgfile3();
	imgfile[3] = detail.getImgfile4();
	imgfile[4] = detail.getImgfile5();
	
	
	apprsl = olpD.getPre_apprsl(car_mng_id);
	Vector actns = olpD.getActns();

	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP"); //사원전체리스트
	int user_size = users.size();
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	//상품평가 수정 등록 구분하기 위해
	String apprsl_car_mng_id = olyD.getApprsl_Car_mng_id(car_mng_id);
	
	//희망가,시작가 퍼센트
	int carpr = detail.getCar_cs_amt()+detail.getCar_cv_amt()+detail.getOpt_cs_amt()+detail.getOpt_cv_amt()+detail.getClr_cs_amt()+detail.getClr_cv_amt();
	double hppr_per=0.0D, stpr_per=0.0D;
	double hppr = apprsl.getHppr();
	double stpr = apprsl.getStpr();
	if(carpr==0){
		hppr_per = 0;
		stpr_per = 0;
	}else{
		hppr_per = (hppr*100)/carpr;
		stpr_per = (stpr*100)/carpr;
	}

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
		
	return ch_year + ChangeNum(ch_month) + ChangeNum(ch_day);
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
	fm.action="/acar/off_ls_jh/off_ls_jh_apprsl_upd.jsp";
	fm.target = "i_no";	
	fm.submit();
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
		window.open("/acar/off_lease/off_lease_imgAppend.jsp?car_mng_id=<%=car_mng_id%>&imgfile1=<%=detail.getImgfile1()%>&imgfile2=<%=detail.getImgfile2()%>&imgfile3=<%=detail.getImgfile3()%>&imgfile4=<%=detail.getImgfile4()%>&imgfile5=<%=detail.getImgfile5()%>", "imgAppend", "left=300, top=200, width=400, height=100, resizable=no, scorllbars=no");
	<%}%>
}
function imgDelete(){

	if(!confirm('이미지를 삭제하시겠습니까?')){ return; }
	var fm = document.form1;
	fm.action = "/acar/off_lease/off_lease_imgDelete.jsp";
	fm.target = "i_no";
	fm.imgnum.value = imgnum;
	fm.submit();
}
function list(){
	var fm = document.form1;
	fm.action = "off_ls_pre_frame.jsp";
	fm.submit();	
}
function add_actn(){
	var url = "?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
	var SUBWIN = "off_ls_pre_actn_i.jsp"+url;
	window.open(SUBWIN, "View_ADD_ACTN", "left=100, top=100, width=820, height=400, resizable=no, scrollbars=no");
}
function getHpprPer(){
	var fm = document.form1;
	var hppr = toInt(parseDigit(fm.hppr.value));
	var carpr = toInt(parseDigit(fm.carpr.value));
	var per = (hppr*100)/carpr;
	fm.hppr.value = parseDecimal2(hppr);
	fm.hppr_per.value = per;
}
function getStprPer(){
	var fm = document.form1;
	var stpr = toInt(parseDigit(fm.stpr.value));
	var carpr = toInt(parseDigit(fm.carpr.value));
	var per = (stpr*100)/carpr;
	fm.stpr.value = parseDecimal2(stpr);
	fm.stpr_per.value = per;	
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
      <td colspan="2"> <<기본정보>> <a href='javascript:list()'> </a></td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding='0' >
          <tr> 
            <td class='title' width='120'>차량코드</td>
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
            <td align="center" width="130"><%=detail.getFuel_kd()%></td>
            <td align="center" width="150"><%=detail.getDpm()%> cc</td>
            <td align="center" width="150"><%=detail.getCar_y_form()%></td>
            <td align="center" width="250"><%=detail.getCar_form()%> </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2"></td>
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
						<%}else{}%>" name="carImg" border="0" width="120" height="120"></td>
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
              <a href="#" onClick="show(<%=i%>)"><<%=j++%>></a> 
              <%}
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
      <td colspan="2"></td>
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
            <td align='center' width="180"></td>
            <td class='title' width='100'> 보험유효기간</td>
            <td width='150'>&nbsp;&nbsp; </td>
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
      <td colspan="2"></td>
    </tr>
    <tr> 
      <td align='left'><a name="apprsl"><<상품평가>></a></td>
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
            <td>&nbsp; 
              <select name='lev'>
                <option value='0'>선택</option>
                <option value='1' <%if(apprsl.getLev().equals("1")){%>selected<%}%>>상</option>
                <option value='2' <%if(apprsl.getLev().equals("2")){%>selected<%}%>>중</option>
                <option value='3' <%if(apprsl.getLev().equals("3")){%>selected<%}%>>하</option>
              </select>
            </td>
            <td class='title'>평가일자</td>
            <td>&nbsp; 
              <input  class="text" type="text" name="apprsl_dt" size="20" value="<%=AddUtil.ChangeDate2(apprsl.getApprsl_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">평가요인</td>
            <td colspan="3">&nbsp; 
              <textarea  class="textarea" name="reason" cols="70" rows="2"><%=apprsl.getReason()%></textarea>
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">차량상태</td>
            <td colspan="3">&nbsp; 
              <input  class="text" type="text" name="car_st" size="70" value="<%=apprsl.getCar_st()%>">
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">사고유무</td>
            <td width="280"> &nbsp; 
              <select name='sago_yn'>
                <option value=''>선택</option>
                <option value='Y' <%if(apprsl.getSago_yn().equals("Y")){%>selected<%}%>>유</option>
                <option value='N' <%if(apprsl.getSago_yn().equals("N")){%>selected<%}%>>무</option>
              </select>
            </td>
            <td width="120" class="title">LPG유무</td>
            <td width="280"> &nbsp; 
              <select name='lpg_yn'>
                <option value=''>선택</option>
                <option value='Y' <%if(apprsl.getLpg_yn().equals("Y")){%>selected<%}%>>유</option>
                <option value='N' <%if(apprsl.getLpg_yn().equals("N")){%>selected<%}%>>무</option>
              </select>
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">차량실제주행거리</td>
            <td> &nbsp; 
              <input  class="num" type="text" name="km" size="20" value="<%=AddUtil.parseDecimal(apprsl.getKm())%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
              KM </td>
            <td class='title'>출품경매장</td>
            <td> 
              <select name='client_id'>
                <option value=''>선택</option>
                <%for(int i=0; i<actns.size(); i++){
					Hashtable ht = (Hashtable)actns.elementAt(i);%>
                <option value='<%=ht.get("CLIENT_ID")%>' <%if(ht.get("CLIENT_ID").equals(apprsl.getActn_id())){%>selected<%}%>><%=ht.get("FIRM_NM")%></option>
                <%}%>
              </select>
              &nbsp; 
              <%//<a href='javascript:add_actn();' onMouseOver="window.status=''; return true"> 
              //<img src="/images/add.gif" width="50" height="18" align="absmiddle" border="0" alt="추가"></a> 
            %>
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">담당자평가</td>
            <td colspan="3"> &nbsp; 
              <textarea  class="textarea" name="damdang" cols="70" rows="2"><%=apprsl.getDamdang()%></textarea>
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">변경전차량번호</td>
            <td> &nbsp;&nbsp; 
              <%if(detail.getCar_pre_no().equals("")){%>
              없음 
              <%}else{%>
              <%=detail.getCar_pre_no()%> &nbsp; 
              <%}%>
            </td>
            <td class="title">차량번호변경일</td>
            <td>&nbsp;<%=AddUtil.ChangeDate2(detail.getCha_dt())%> </td>
          </tr>
          <tr> 
            <td class='title' width="120">담당자</td>
            <td>&nbsp; 
              <select name="damdang_id">
                <option value='' <%if(apprsl.getDamdang_id().equals("")){%>selected<%}%>>선택</option>
                <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	
%>
                <option value='<%=user.get("USER_ID")%>' <%if(apprsl.getDamdang_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                <%
						}
					}		%>
              </select>
            </td>
            <td class="title">최종수정자</td>
            <td>&nbsp; 
              <%if(login.getAcarName(apprsl.getModify_id()).equals("error")){%>
              &nbsp; 
              <%}else{%>
              <%=login.getAcarName(apprsl.getModify_id())%> 
              <%}%>
              &nbsp; </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2"></td>
    </tr>
    <tr> 
      <td align='left'><< 상품가격결정 >><a href='javascript:apprslUpd();' onMouseOver="window.status=''; return true"> 
        </a> </td>
      <td align='right'>
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
            <td class='title' width="200">최종결정자</td>
            <td class='title' width="200">신차가</td>
            <td class='title' width="200">희망가(신차대비)</td>
            <td class='title' width="200">시작가(신차대비)</td>
          </tr>
          <tr> 
            <td width="200" align="center"> 
              <select name="determ_id">
                <option value='' <%if(apprsl.getDeterm_id().equals("")){%>selected<%}%>>선택</option>
                <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	
%>
                <option value='<%=user.get("USER_ID")%>' <%if(apprsl.getDeterm_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                <%
						}
					}		%>
              </select>
            </td>
            <td width="200"  align="center"> 
              <input  class="num" type="text" name="carpr" size="12" value="<%=AddUtil.parseDecimal(carpr)%>">
              원 </td>
            <td width="200"  align="center"> 
              <input  class="num" type="text" name="hppr" size="12" value="<%=AddUtil.parseDecimal(apprsl.getHppr())%>" onChange="javascript:getHpprPer()">
              (<input  class="white" type="text" name="hppr_per" size="5" value="<%=AddUtil.parseDecimal(hppr_per)%>">%)</td>
            <td width="200"  align="center"> 
              <input  class="num" type="text" name="stpr" size="12" value="<%=AddUtil.parseDecimal(apprsl.getStpr())%>" onChange="javascript:getStprPer()">
              (<input  class="white" type="text" name="stpr_per" size="5" value="<%=AddUtil.parseDecimal(stpr_per)%>" >%)</td>
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