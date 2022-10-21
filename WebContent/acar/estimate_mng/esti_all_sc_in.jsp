<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
		
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	//공통변수
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	Vector vt = e_db.getEstimateAllList(gubun1, gubun2, gubun3, s_dt, e_dt, s_kd, t_wd);		
	int vt_size = vt.size();
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	
//-->
</script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}	
	
	//전체선택
	function AllSelect() {
		var fm = document.form1;
		//var len = fm.elements.length;
		var len = document.getElementsByName("ch_l_cd").length;
		var cnt = 0;
		var idnum = "";
		for (var i = 0; i < len; i++) {
			//var ck = fm.elements[i];
			var ck = document.getElementsByName("ch_l_cd")[i];
			if (ck.checked == false) {
				ck.click();
			} else {
				ck.click();
			}
		}
	}	
-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">  
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="s_dt" value="<%=s_dt%>">
  <input type="hidden" name="e_dt" value="<%=e_dt%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">          
  <input type="hidden" name="t_wd" value="<%=t_wd%>"> 
  
<table border=0 cellspacing=0 cellpadding=0 width=1650>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'> 
        <td width=500 class='line' id='td_title' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=40 class=title>연번</td>
		            <td width=40 class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>					                    
                    <td width=80 class=title>견적구분</td>
                    <td width=110 class=title>계약번호</td>
                    <td width=80 class=title>차량번호</td>
                    <td width=150 class=title>일련번호</td>
                </tr>
            </table>
        </td>
        <td class='line' width=1150>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=100 class=title>EST_NM</td>
                    <td width=100 class=title>EST_SSN</td>
                    <td width=100 class=title>EST_TEL</td>
                    <td width=50 class=title>JOB</td>
                    <td width=100 class=title>견적일자</td>
                    <td width=110 class=title>상품</td>
                    <td width=40 class=title>기간</td>
                    <td width=100 class=title>약정운행거리</td>
                    <td width=100 class=title>주행거리</td>
		            <td width=100 class=title>차량가격</td>
                    <td width=100 class=title>대여료(공급가)</td>
                    <td width=100 class=title>매입옵션</td>
                    <td width=50 class=title>위약율</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td width=500 class='line' id='td_con' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
	          <%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td width=40 align=center><%=i+1%></td>
		            <td width=40 align=center><input type="checkbox" name="ch_l_cd" value="<%=ht.get("ST")%><%=ht.get("EST_ID")%>"></td>                    		    
                    <td width=80 align=center><%=ht.get("EST_FROM")%></td>
                    <td width=110 align=center><%=ht.get("RENT_L_CD")%> <%=ht.get("RENT_ST")%></td>
                    <td width=80 align=center><%=ht.get("CAR_NO")%></td>
                    <td width=150 align=center><%=ht.get("EST_ID")%></td>
                </tr>
              <%	}%>
            </table>
        </td>
        <td width=1150 class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
			    <%	for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td width=100 align="center"><span title='<%=ht.get("EST_NM")%>'><%=Util.subData(String.valueOf(ht.get("EST_NM")), 6)%></span></td>
                    <td width=100 align="center"><%=ht.get("EST_SSN")%></td>
                    <td width=100 align="center"><%=ht.get("EST_TEL")%></td>
                    <td width=50 align="center"><%=ht.get("JOB")%></td>
                    <td width=100 align="center"><%=ht.get("RENT_DT")%></td>
                    <td width=110 align="center"><%=c_db.getNameByIdCode("0009", "", String.valueOf(ht.get("A_A")))%></td>
                    <td width=40 align="center"><%=ht.get("A_B")%>개월</td>
                    <td width=100 align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGREE_DIST")))%>km</td>
                    <td width=100 align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("TODAY_DIST")))%>km</td>
                    <td width=100 align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("O_1")))%>원</td>
                    <td width=100 align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>원</td>					
                    <td width=100 align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("RO_13_AMT")))%>원</td>
                    <td width=50 align=center><%=ht.get("CLS_PER")%>%</td>
                </tr>
              <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
