<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_pre.Offls_preBean"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	detail = olpD.getPre_detail(car_mng_id);
	String imgfile[] = new String[5];
	imgfile[0] = detail.getImgfile1();
	imgfile[1] = detail.getImgfile2();
	imgfile[2] = detail.getImgfile3();
	imgfile[3] = detail.getImgfile4();
	imgfile[4] = detail.getImgfile5();
	
	//차량정보
	Hashtable sh_ht = shDb.getShBase(car_mng_id);	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
		window.open("/acar/res_search/car_img_add_all.jsp?c_id=<%=car_mng_id%>&car_no=<%=detail.getCar_no()%>", "imgAppend", "left=300, top=200, width=820, height=600, resizable=no, scorllbars=no");
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
function list(){
	var fm = document.form1;
	fm.action = "off_ls_pre_frame.jsp";
	fm.submit();	
}
function imgBig(){
	var imgName = document.form1.carImg.value;
	window.open("/acar/secondhand_hp/bigimg.jsp?c_id=<%=car_mng_id%>","imgBig", "left=200, top=100, width=800, height=600, resizable=yes, scorllbars=no");
}
//-->
</script>
</head>
<body>
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="imgnum" value="">
<input type="hidden" name="gubun" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기본정보</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding='0' width="100%">
                <tr> 
                    <td class='title' width=16%>차량연번</td>
                    <td class='title' width=21%>차량번호</td>
                    <td class='title' width=21%>최초등록일</td>
                    <td class='title' width=21%>출고일</td>
                    <td class='title' width=21%>차대번호</td>
                </tr>
                <tr> 
                    <td align="center"><%=detail.getCar_l_cd()%></td>
                    <td align="center"><%=detail.getCar_no()%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(detail.getInit_reg_dt())%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(detail.getDlv_dt())%></td>
                    <td align="center"><%=detail.getCar_num()%></td>
                </tr>
                <tr> 
                    <td class='title'>용도</td>
                    <td class='title'>연료</td>
                    <td class='title'>배기량</td>
                    <td class='title'>연식</td>
                    <td class='title'>형식</td>
                </tr>
                <tr> 
                    <td align="center"> <%if(detail.getCar_use().equals("1")){%>
                      렌트사업용 
                      <%}else{%>
                      리스사업용 
                      <%}%> </td>
                    <td align="center"><%=c_db.getNameByIdCode("0039", "", detail.getFuel_kd())%></td>
                    <td align="center"><%=detail.getDpm()%> cc</td>
                    <td align="center"><%=detail.getCar_y_form()%></td>
                    <td align="center"><%=detail.getCar_form()%> </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2"></td>
    </tr>
    <tr> 
        <td align='left' colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량가격</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding='0' width="100%" >
                <tr> 
                    <td rowspan="6"  width=16% align="center"> <img src="<%if(!imgfile[0].equals("")){%>	
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile1()%>.gif
						<%}else if(!detail.getImgfile2().equals("")){%>
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile2()%>.gif
						<%}else if(!detail.getImgfile3().equals("")){%>
					        https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile3()%>.gif
						<%}else if(!detail.getImgfile4().equals("")){%>
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile4()%>.gif
						<%}else if(!detail.getImgfile5().equals("")){%>
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile5()%>.gif
						<%}else{%>
							https://fms3.amazoncar.co.kr/images/no_photo.gif
						<%}%>" 
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
						<%}else{%>
							https://fms3.amazoncar.co.kr/images/no_photo.gif
						<%}%>" 
						border="0" width="150" height="120" onclick="javascript:imgBig()"
						alt="큰이미지를 보실려면 클릭!"></td>
                    <td rowspan="2"  class='title' width=7%>구분</td>
                    <td class='title' rowspan="2" width=14%>명칭</td>
                    <td class="title" colspan="3">소비자가</td>
                    <td class="title" colspan="3">구입가</td>
                </tr>
                <tr> 
                    <td  class='title' width=10%>공급가</td>
                    <td  class='title' width=11%>부가세</td>
                    <td  class='title' width=11%>합계</td>
                    <td  class='title' width=10%>공급가</td>
                    <td  class='title' width=10%>부가세</td>
                    <td  class='title' width=11%>합계</td>
                </tr>
                <tr> 
                    <td align="center" >차명</td>
                    <td align="center"><span title='<%=detail.getCar_jnm()+" "+detail.getCar_nm()%>'><%=AddUtil.subData(detail.getCar_jnm()+" "+detail.getCar_nm(),8)%></span></td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_cs_amt()+detail.getCar_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_fs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_fv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_fs_amt()+detail.getCar_fv_amt())%>&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">옵션</td>
                    <td align="center"><span title='<%=detail.getOpt()%>'><%=AddUtil.subData(detail.getOpt(),8)%></span></td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_cs_amt()+detail.getOpt_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_fs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_fv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_fs_amt()+detail.getOpt_fv_amt())%>&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">색상</td>
                    <td align="center"><span title='<%=detail.getColo()%>'><%=AddUtil.subData(detail.getColo(),8)%></span></td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_cs_amt()+detail.getClr_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_fs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_fv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_fs_amt()+detail.getClr_fv_amt())%>&nbsp;</td>
                </tr>
                <tr> 
                    <td colspan="2" align="center">매출DC</td>
                    <td align="right">0
                        <%//=AddUtil.parseDecimal(detail.getDc_cs_amt())%>&nbsp;</td>
                    <td align="right">0
                        <%//=AddUtil.parseDecimal(detail.getDc_cv_amt())%>&nbsp;</td>
                    <td align="right">0
                        <%//=AddUtil.parseDecimal(detail.getDc_cs_amt()+detail.getDc_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getDc_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getDc_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getDc_cs_amt()+detail.getDc_cv_amt())%>&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" rowspan='2'> <%
        			int j=1;
        			for(int i=0; i<imgfile.length; i++){
        				if(!imgfile[i].equals("")){%> <a href="#" onClick="show(<%=i%>)"><%if(j==1){%><img src=../images/center/button_front_s.gif align=absmiddle border=0>
        					<%}else if(j==2){%><img src=../images/center/button_in.gif align=absmiddle border=0>
        					<%}else if(j==3){%><img src=../images/center/button_back.gif align=absmiddle border=0> 
        					<%}else if(j==4){%><img src=../images/center/button_back_s.gif align=absmiddle border=0>
        					<%}else if(j==5){%><img src=../images/center/button_front.gif align=absmiddle border=0>
        					<%}%></a>
        				<%}
        				j++;
        			}
        			for(int i=0; i<imgfile.length; i++){
        				if(!imgfile[i].equals("")){%> <script language="javascript">
        						imgnum = <%=i%>;
        						//alert(imgnum);
        					</script> <%break;
        				}
        			}
        			if(imgfile[0].equals("") && imgfile[1].equals("") && imgfile[2].equals("") && imgfile[3].equals("") && imgfile[4].equals("")){%>
                      <a href='javascript:imgAppend();'><img src=../images/center/button_in_plus.gif align=absmiddle border=0></a> 
                      <%}%> </td>
                    <td colspan="2" align="center">탁송료</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_cs_amt()+detail.getSd_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_fs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_fv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_fs_amt()+detail.getSd_fv_amt())%>&nbsp;</td>
                </tr>
                <tr> 
                    <!--<td align="center"> <%if(auth_rw.equals("4")||auth_rw.equals("6")){
        			  		if(imgfile[0].equals("") && imgfile[1].equals("") && imgfile[2].equals("") && imgfile[3].equals("") && imgfile[4].equals("")){%>
                      <a href='javascript:imgAppend();' onMouseOver="window.status=''; return true"> 
                      <img src=../images/center/button_in_plus.gif align=absmiddle border=0></a> 
                      <%}else{%> <a href='javascript:imgAppend();' onMouseOver="window.status=''; return true"> 
                      <img src=../images/center/button_in_plus.gif align=absmiddle border=0></a> 
                      &nbsp;&nbsp;<a href='javascript:imgDelete();' onMouseOver="window.status=''; return true"> 
                      <img src=../images/center/button_in_delete.gif align=absmiddle border=0></a> 
                      <%}
        			  }%> </td>
					  -->
                    <td colspan="2" align="center" class=title>합 계</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_cs_amt()+detail.getOpt_cs_amt()+detail.getClr_cs_amt()+detail.getSd_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_cv_amt()+detail.getOpt_cv_amt()+detail.getClr_cv_amt()+detail.getSd_cv_amt())%>&nbsp;</td>
                    <td align="right"><b><%=AddUtil.parseDecimal(detail.getCar_cs_amt()+detail.getOpt_cs_amt()+detail.getClr_cs_amt()+detail.getSd_cs_amt()+detail.getCar_cv_amt()+detail.getOpt_cv_amt()+detail.getClr_cv_amt()+detail.getSd_cv_amt())%></b>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_fs_amt()+detail.getOpt_fs_amt()+detail.getClr_fs_amt()+detail.getSd_fs_amt()-detail.getDc_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_fv_amt()+detail.getOpt_fv_amt()+detail.getClr_fv_amt()+detail.getSd_fv_amt()-detail.getDc_cv_amt())%>&nbsp;</td>
                    <td align="right"><b><%=AddUtil.parseDecimal(detail.getCar_fs_amt()+detail.getOpt_fs_amt()+detail.getClr_fs_amt()+detail.getSd_fs_amt()-detail.getDc_cs_amt()+detail.getCar_fv_amt()+detail.getOpt_fv_amt()+detail.getClr_fv_amt()+detail.getSd_fv_amt()-detail.getDc_cv_amt())%></b>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2"></td>
    </tr>
    <tr> 
        <td align='left' colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기타정보</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                    <td class='title' width=16%> 할부금융사</td>
                    <td align='center' width=21%> <%if(detail.getBank_nm().equals("")){%>
                      - 
                      <%}else{%> <%=detail.getBank_nm()%> <%}%> </td>
                    <td class='title' width=14%> 대출금액</td>
                    <td align='center' width=18%><%=AddUtil.parseDecimal(detail.getLend_prn())%>&nbsp;원</td>
                    <td class='title' width=13%>상환원금잔액</td>
                    <td align='center' width=18%><%=AddUtil.parseDecimal(detail.getLend_rem())%>&nbsp;원</td>
                </tr>
                <tr> 
                    <td class='title'> 보험사</td>
                    <td align='center'><%= detail.getIns_com_nm() %></td>
                    <td class='title'> 보험유효기간</td>
                    <td align='center'><%= AddUtil.ChangeDate2(detail.getIns_exp_dt()) %></td>
                    <td class='title'>상환만료일</td>
                    <td align="center"><%=AddUtil.ChangeDate2(detail.getAlt_end_dt())%></td>
                </tr>
                <tr> 
                    <td class='title'>정기검사유효기간</td>
                    <td align='center'><%=AddUtil.ChangeDate2(detail.getMaint_st_dt())%> ~ <%=AddUtil.ChangeDate2(detail.getMaint_end_dt())%></td>
                    <td class='title'> 누적주행거리</td>
                    <td align="center"><%=AddUtil.parseDecimal(detail.getToday_dist())%> km</td>
                    <td class="title" align="center">평균주행거리</td>
                    <td align="center" ><%=AddUtil.parseDecimal(detail.getAverage_dist())%> km</td>
                </tr>
                <tr> 
                    <td class='title'>점검유효기간</td>
                    <td align='center'><%=AddUtil.ChangeDate2(detail.getTest_st_dt())%> ~ <%=AddUtil.ChangeDate2(detail.getTest_end_dt())%></td>
					<td class="title" align="center">차령만료일</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(sh_ht.get("CAR_END_DT")))%></td>
                    <td class='title'>구조변경</td>
                    <td align="center"> <%if(detail.getCar_cha_yn().equals("1")){%> &nbsp;있음 
                      <%}else{%> &nbsp;없음 
                      <%}%> </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2"></td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="./off_ls_pre_sc_in_b_apprsl.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>" name="in_apprsl" width="100%" height="240" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="./off_ls_pre_sc_in_b_auction.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>" name="in_apprsl" width="100%" height="100" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="./off_ls_pre_sc_in_b_car_pur.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>" name="in_apprsl" width="100%" height="100" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>