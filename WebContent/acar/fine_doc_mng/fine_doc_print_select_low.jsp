<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>	
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>
	
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>

<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

</style>
<script>

window.onbeforeprint = function(){
	//setCookie();
};

function setCookie(cName, cValue, cMinutes){

 	var expire = new Date();
    expire.setDate(expire.getMinutes() + cMinutes);
    cookies = cName + '=' + escape(cValue) + '; path=/ ; domain=.amazoncar.co.kr';
    if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
    document.cookie = cookies;
    
}

// 쿠키 가져오기
function getCookie(cName) {
    cName = cName + '=';
    var cookieData = document.cookie;
    var start = cookieData.indexOf(cName);
    var cValue = '';
    if(start != -1){
        start += cName.length;
        var end = cookieData.indexOf(';', start);
        if(end == -1)end = cookieData.length;
        cValue = cookieData.substring(start, end);
    }
    return unescape(cValue);
}

setCookie('tmp_waste', 'delete', 1);

</script>

<!-- <SCRIPT>
	function Installed(){
		try{	return (new ActiveXObject('IEPageSetupX.IEPageSetup'));	}
		catch (e){	return false;	}
	}

	function PrintTest(){
		if (!Installed()){
			alert("컨트롤이 설치되지 않았습니다. 정상적으로 인쇄되지 않을 수 있습니다.")
			return false;
		}else{
			alert("정상적으로 설치되었습니다.");
			alert("기본프린트 : "+IEPageSetupX.GetDefaultPrinter());
		}	
	}
</SCRIPT> -->
<!-- <SCRIPT language="JavaScript" for="IEPageSetupX" event="OnError(ErrCode, ErrMsg)">
	alert('에러 코드: ' + ErrCode + "\n에러 메시지: " + ErrMsg);
</SCRIPT> -->

</head>
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="./IEPageSetupX.cab#version=1,4,0,3" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
	<div style="position:absolute;top:276;left:320;width:300;height:68;border:solid 1 #99B3A0;background:#D8D7C4;overflow:hidden;z-index:1;visibility:visible;"><FONT style='font-family: "굴림", "Verdana"; font-size: 9pt; font-style: normal;'>
	<BR>  인쇄 여백제어 컨트롤이 설치되지 않았습니다.  <BR>  <a href="https://www.amazoncar.co.kr/IEPageSetupX.exe"><font color=red>이곳</font></a>을 클릭하여 수동으로 설치하시기 바랍니다.  </FONT>
	</div>
</OBJECT> -->
<body leftmargin="15" topmargin="1" onload="javascript:window.onprint();">
<!-- <object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object>  -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String find_type = request.getParameter("find_type")==null?"":request.getParameter("find_type");
	String doc_id = "";
	String doc_dt 	= "";
	
	
	AddForfeitDatabase afm_db = AddForfeitDatabase.getInstance();
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	
	String vid[] = request.getParameterValues("ch_l_cd");
	String vid2[] = request.getParameterValues("ch_doc_id");
	String vid3[] = request.getParameterValues("ch_cnt");
	String mode 	 = "b-lazy";
	String list_size = "";
	String vid_num   = "";
	String img_url   = "";
	
	double img_width 	= 690;
	double img_height 	= 1009;

	int vid_size = vid.length;
	
	for(int j=0;j < vid_size;j++){
		if(find_type.equals("popOne")){
			doc_id	= request.getParameter("ch_doc_id")==null?"":request.getParameter("ch_doc_id");
		}else{
			vid_num 	= vid[j];
			doc_id 		= vid2[AddUtil.parseInt(vid_num)];
		}		
		img_url		= doc_id;
		
		if(!doc_id.equals("")){
		
			FineDocBn = FineDocDb.getFineDoc(doc_id);
			FineGovBn = FineDocDb.getFineGov(FineDocBn.getGov_id());
			
			doc_dt = FineDocBn.getDoc_dt();
	
			//과태료리스트
			Vector FineList = FineDocDb.getFineDocLists(doc_id);
			

%>
<%if(mode.equals("b-lazy")){%>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/blazy@1.8.2/blazy.min.js"></script>
<%}%>
<!-- 과태료공문 -->
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" class="a4">
	<tr>
		<td height=1009>
			<jsp:include page="/acar/fine_doc_mng/i_fine_doc_print.jsp" flush="true">
          <jsp:param name="doc_id" value="<%=doc_id%>"/>
          <jsp:param name="user_id" value="<%=user_id%>"/>
          <jsp:param name="mode" value="fine"/>
			</jsp:include>
		</td>
	</tr>
</table>

  
<%
			if(FineList.size()>0){
				for(int i=0; i<FineList.size(); i++){ 
					FineDocListBn = (FineDocListBean)FineList.elementAt(i); 
					String rent_mng_id 	= FineDocListBn.getRent_mng_id();
					String rent_l_cd 		= FineDocListBn.getRent_l_cd();
					String rent_mng_id2 = FineDocListBn.getSub_rent_mng_id();
					String rent_l_cd2 	= FineDocListBn.getSub_rent_l_cd();
					String client_id 		= FineDocListBn.getClient_id();
					String vio_dt 			= FineDocListBn.getVio_dt();
					String rent_s_cd 		= FineDocListBn.getRent_s_cd();
					String car_mng_id		= FineDocListBn.getCar_mng_id();
					String car_st				= FineDocListBn.getCar_st();
					String rent_st			= FineDocListBn.getRent_st();
					String rent_start_dt= FineDocListBn.getRent_start_dt();
					String rent_end_dt	= FineDocListBn.getRent_end_dt();
					int    seq_no 			= FineDocListBn.getSeq_no();
					
					if(rent_st.equals("")){
						//대여기간에 맞는 과태료 입력 확인
						rent_st = afm_db.getFineSearchRentst(rent_mng_id, rent_l_cd, vio_dt);
					}
					if(!rent_s_cd.equals("")){
						//대여기간에 맞는 과태료 입력 확인
						rent_st = afm_db.getFineSearchRentst(rent_mng_id2, rent_l_cd2, vio_dt);
					}
%>

<!--과태료 청구서 스캔파일-->
			<jsp:include page="i_fine_fscan_print.jsp" flush="true">
          <jsp:param name="rent_mng_id" value="<%=rent_mng_id%>"/>
          <jsp:param name="rent_l_cd" value="<%=rent_l_cd%>"/>
          <jsp:param name="client_id" value="<%=client_id%>"/>
          <jsp:param name="car_mng_id" value="<%=car_mng_id%>"/>
          <jsp:param name="mode" value="b-lazy"/>
         	<jsp:param name="doc_id" value="<%=doc_id%>"/>
         	<jsp:param name="vio_dt" value="<%=vio_dt%>"/>
         	<jsp:param name="seq_no" value="<%=seq_no%>"/>
			</jsp:include>


<!--자동차대차이용계약서-->
<%				if(!rent_s_cd.equals("")){%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" class="a4">
	<tr>
		<td height=1009>
			
			<jsp:include page="i_fine_scont_print.jsp" flush="true">
          <jsp:param name="c_id" value="<%=car_mng_id%>"/>
          <jsp:param name="s_cd" value="<%=rent_s_cd%>"/>
          <jsp:param name="mode" value="fine"/>
			</jsp:include>
		</td>
	</tr>
</table>

<!--자동차대여이용계약서-->
<%				}else{%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" class="a4">
	<tr>
		<td height=1009>
			<jsp:include page="i_fine_lcont_print.jsp" flush="true">
          <jsp:param name="rent_mng_id" value="<%=rent_mng_id%>"/>
          <jsp:param name="rent_l_cd" value="<%=rent_l_cd%>"/>
          <jsp:param name="rent_st" value="<%=rent_st%>"/>
          <jsp:param name="doc_dt" value="<%=doc_dt%>"/>
          <jsp:param name="rent_start_dt" value="<%=rent_start_dt%>"/>
          <jsp:param name="rent_end_dt" value="<%=rent_end_dt%>"/>
          <jsp:param name="vio_dt" value="<%=vio_dt%>"/>
          <jsp:param name="mode" value="fine"/>
			</jsp:include>
		</td>
	</tr>
</table>
<%				}%>


<!--계약서외 스캔파일-->
			<jsp:include page="i_fine_lscan_print.jsp" flush="true">
	          <jsp:param name="rent_mng_id" value="<%=rent_mng_id%>"/>
	          <jsp:param name="rent_l_cd" value="<%=rent_l_cd%>"/>
	          <jsp:param name="rent_mng_id2" value="<%=rent_mng_id2%>"/>
	          <jsp:param name="rent_l_cd2" value="<%=rent_l_cd2%>"/>
	          <jsp:param name="client_id" value="<%=client_id%>"/>
	          <jsp:param name="car_mng_id" value="<%=car_mng_id%>"/>
	          <jsp:param name="rent_s_cd" value="<%=rent_s_cd%>"/>
	          <jsp:param name="rent_st" value="<%=rent_st%>"/>
	          <jsp:param name="mode" value="b-lazy"/>
			</jsp:include>
	<%}%>
<%			
			}
		}
	}
%>
<%if(mode.equals("b-lazy")){%>
<script>
    var bLazy = new Blazy({ });
</script>
<%}%>
</body>
</html>
<script>
//onprint();
//5초후에 인쇄박스 팝업
//setTimeout(onprint_box,5000);

function IE_Print() {
	factory1.printing.header = ""; //폐이지상단 인쇄
	factory1.printing.footer = ""; //폐이지하단 인쇄
	factory1.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
 	factory1.printing.leftMargin = 10.0; //좌측여백   
 	factory1.printing.rightMargin = 10.0; //우측여백
 	factory1.printing.topMargin = 17.0; //상단여백    
// 	factory1.printing.bottomMargin = 0.0; //하단여백
	factory1.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}

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
	
									//~IE10									  //IE8~IE11		
// 	if( navigator.userAgent.indexOf("MSIE") > 0 || navigator.userAgent.indexOf("Trident") > 0){
// 		IEPageSetupX.header='';				//폐이지상단 인쇄
// 		IEPageSetupX.footer='';				//폐이지하단 인쇄
// 		IEPageSetupX.Orientation = 1;		//1-세로인쇄, 2-가로인쇄
// 		IEPageSetupX.leftMargin=10.0;		//좌측여백
// 		IEPageSetupX.rightMargin=10.0;		//우측여백
// 		IEPageSetupX.topMargin=17.0;		//상단여백
// 		IEPageSetupX.bottomMargin=0;		//하단여백
// 		IEPageSetupX.PaperSize = 'A4';		//인쇄용지설정
// 		IEPageSetupX.PrintBackground = 1;	//배경색 및 이미지 인쇄 여부 설정
// 		IEPageSetupX.Print(true);			//인쇄 대화상자표시여부(true-표시 , 공백/false- 표시안함(바로 인쇄))
		
	/* factory.printing.header 	= ""; //폐이지상단 인쇄
	factory.printing.footer 	= ""; //폐이지하단 인쇄
	factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
	factory.printing.leftMargin 	= 10.0; //좌측여백   
	factory.printing.rightMargin 	= 10.0; //우측여백
	factory.printing.topMargin 	= 10.0; //상단여백    
	factory.printing.bottomMargin 	= 10.0; //하단여백 */
// 	}else{	
// 		window.print();
// 	}
}
function onprint_box(){
	factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}

</script>
