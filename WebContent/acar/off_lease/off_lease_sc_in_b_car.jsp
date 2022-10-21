<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_yb.*"%>
<jsp:useBean id="olyD" class="acar.offls_yb.Offls_ybDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	Offls_ybBean detail = olyD.getYb_detail(car_mng_id);
	String imgfile[] = new String[5];
	imgfile[0] = detail.getImgfile1();
	imgfile[1] = detail.getImgfile2();
	imgfile[2] = detail.getImgfile3();
	imgfile[3] = detail.getImgfile4();
	imgfile[4] = detail.getImgfile5();
	

	

	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//상품평가 수정 등록 구분하기 위해
	String apprsl_car_mng_id = olyD.getApprsl_Car_mng_id(car_mng_id);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
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
		window.open("./off_lease_imgAppend.jsp?car_mng_id=<%=car_mng_id%>&imgfile1=<%=detail.getImgfile1()%>&imgfile2=<%=detail.getImgfile2()%>&imgfile3=<%=detail.getImgfile3()%>&imgfile4=<%=detail.getImgfile4()%>&imgfile5=<%=detail.getImgfile5()%>", "imgAppend", "left=300, top=200, width=400, height=100, resizable=no, scorllbars=no");
	<%}%>
}
function imgDelete(){

	if(!confirm('이미지를 삭제하시겠습니까?')){ return; }
	var fm = document.form1;
	fm.action = "./off_lease_imgDelete.jsp";
	fm.target = "i_no";
	fm.imgnum.value = imgnum;
	fm.submit();
}
function imgBig(){
	var imgName = document.form1.carImg.value;
	window.open("./off_lease_imgBig.jsp?car_mng_id=<%=car_mng_id%>&imgName="+imgName,"imgBig", "left=200, top=100, width=450, height=300, resizable=no, scorllbars=no");
}
-->
</script>
</head>

<body>
<table width="800" border="0" cellspacing="1" cellpadding="0">
  <tr>
    <td>&lt;&lt; 차량가격 &gt;&gt;</td>
  </tr>
  <tr>
    <td class="line"><table border="0" cellspacing="1" cellpadding='0' width="800" >
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
      </table></td>
  </tr>
</table>
</body>
</html>
