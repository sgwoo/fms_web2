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
<table width="130" border="0" cellspacing="1" cellpadding="0">
  <tr>
    <td align="center"><img src="<%if(!imgfile[0].equals("")){%>	
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
  </tr>
  <tr>
    <td align="center"> <%
			int j=1;
			for(int i=0; i<imgfile.length; i++){
				if(!imgfile[i].equals("")){%> <a href="#" onClick="show(<%=i%>)"><<%=j++%>></a> <%}
			}
			for(int i=0; i<imgfile.length; i++){
				if(!imgfile[i].equals("")){%> <script language="javascript">
						imgnum = <%=i%>;
						//alert(imgnum);
					</script> <%break;
				}
			}
			if(imgfile[0].equals("") && imgfile[1].equals("") && imgfile[2].equals("") && imgfile[3].equals("") && imgfile[4].equals("")){%>
              이미지없음 
              <%}%> </td>
  </tr>
  <tr>
    <td align="center"> <%if(auth_rw.equals("4")||auth_rw.equals("6")){
				if(imgfile[0].equals("") && imgfile[1].equals("") && imgfile[2].equals("") && imgfile[3].equals("") && imgfile[4].equals("")){%> <a href='javascript:imgAppend();' onMouseOver="window.status=''; return true"> 
              <img src="/images/add.gif" width="50" height="18" align="absmiddle" border="0" alt="추가"></a> 
              <%}else{%> <a href='javascript:imgAppend();' onMouseOver="window.status=''; return true"> 
              <img src="/images/add.gif" width="50" height="18" align="absmiddle" border="0" alt="추가"></a> 
              &nbsp;&nbsp;<a href='javascript:imgDelete();' onMouseOver="window.status=''; return true"> 
              <img src="/images/del.gif" width="50" height="18" align="absmiddle" border="0" alt="삭제"></a> 
              <%}
			 }%> </td>
  </tr>
</table>

</body>
</html>
