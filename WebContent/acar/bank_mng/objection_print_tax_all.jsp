<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*, acar.cont.*,acar.car_register.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>

<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>
	
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>



<script language="JavaScript">
<!--
	function pagesetPrint(){
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
// 		IEPageSetupX.header='';
// 		IEPageSetupX.footer='';
// 		IEPageSetupX.leftMargin=10;
// 		IEPageSetupX.rightMargin=10;
// 		IEPageSetupX.topMargin=10;
// 		IEPageSetupX.bottomMargin=10;		
// 		print();
	}
function IE_Print(){
	factory1.printing.header='';
	factory1.printing.footer='';
	factory1.printing.leftMargin=10;
	factory1.printing.rightMargin=10;
	factory1.printing.topMargin=10;
	factory1.printing.bottomMargin=10;
	factory1.printing.Print(true, window);
}
//-->
</script>

</head>
<body leftmargin="15" topmargin=5 onLoad="javascript:pagesetPrint()" >
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
	
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	double img_width 	= 680;
	double img_height 	= 900;

	
//	System.out.println(FineDocBn.getGov_id());
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	//과태료리스트
	Vector FineList = FineDocDb.getBankDocAllLists2(doc_id);
				
	String c_id[] = new String[FineList.size()];
	String l_cd[] = new String[FineList.size()];
	String m_id[] = new String[FineList.size()];
	String c_no[] = new String[FineList.size()];
	
	
	if(FineList.size()>0){
		for(int i=0; i<FineList.size(); i++){ 
			Hashtable ht = (Hashtable)FineList.elementAt(i);
			
			c_id[i] = String.valueOf(ht.get("CAR_MNG_ID"));
			l_cd[i] = String.valueOf(ht.get("RENT_L_CD"));	
			m_id[i] = String.valueOf(ht.get("RENT_MNG_ID"));	
			c_no[i] = String.valueOf(ht.get("CAR_NO"));	
	 	}
	} 

%>

<%

for(int k=0; k<FineList.size(); k++){ 
		String car_mng_id = c_id[k];
		String rent_mng_id = m_id[k];
		String rent_l_cd = l_cd[k];
		String car_no = c_no[k];
		String rent_st = "1";
		String file_st = "10";
	
//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
		int size = 0;

		String content_code = "LC_SCAN";
		String content_seq  = rent_mng_id+rent_l_cd+rent_st+file_st;

		Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
		int attach_vt_size = attach_vt.size();

		for(int j=0; j< attach_vt.size(); j++){
			Hashtable aht = (Hashtable)attach_vt.elementAt(j);   
				
%>
	<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
		<tr>
	        <td height=20></td>
	    </tr>
	    
		<tr>
			<td>차량번호 : <%=car_no%>: <%=car_mng_id%> <br>
				<%if(!aht.get("SEQ").equals("")){%>
				<img src="https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp?SEQ=<%=aht.get("SEQ")%>" width=<%=img_width%> height=<%=img_height%>>
				<%}%>
			</td>
		</tr>
   </table>		
	<%  if ( k == FineList.size()-1 ) {%>
	   <% } else { %>
	   <p style='page-break-before:always'></P>   
	   <% } %>
 <%  } %>
 <%	} %>
  
</body>

</html>

