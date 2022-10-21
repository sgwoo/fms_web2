<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String vio_dt = request.getParameter("vio_dt")==null?"":request.getParameter("vio_dt");
	
	AddForfeitDatabase cdb = AddForfeitDatabase.getInstance();
	
	Vector vt = cdb.getFineRegConsList("cons_oksms", car_mng_id, AddUtil.replace(vio_dt,"-",""));
	int cont_size = vt.size();
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_ts.css">
</head>
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;


	function MM_openBrWindow(theURL,winName,features) { //v2.0
	
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		
		theURL = "https://fms3.amazoncar.co.kr"+theURL;
		
		popObj = window.open('',winName,features);
		popObj.location = theURL
		popObj.focus();
		
	}	
//-->
</script>

<body>
<form action="search_cont.jsp" name="form1" method="POST">
<table border=0 cellspacing=0 cellpadding=0 width=1130>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>탁송조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>탁송현황</span></td>        
    </tr>    
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td rowspan='2' class=title width="50">연번</td>
                  <td rowspan='2' class=title width="100">계약번호</td>
                  <td rowspan='2' class=title width="120">상호</td>
                  <td rowspan='2' class=title width="80">차량번호</td>
                  <td rowspan='2' class=title width="120">차명</td>
                  <td colspan='4' class=title >탁송관리</td>
                  <td colspan='2' class=title >인도/인수문자</td>
                </tr>
                <tr>  
                  <td class=title width="150">출발지</td>
                  <td class=title width="90">출발일시</td>
                  <td class=title width="150">도착지</td>
                  <td class=title width="90">도착일시</td>
                  <td class=title width="90">출발문자발송</td>
                  <td class=title width="90">도착문자발송</td>
                </tr>
                <%  for(int i = 0 ; i < cont_size ; i++){
				              Hashtable ht = (Hashtable)vt.elementAt(i);
				        %>
                <tr> 
                  <td  align="center"><%=i+1%></td>
                  <td  align="center"><%=ht.get("RENT_L_CD")%></td>
                  <td  align="center"><%=ht.get("FIRM_NM")%></td>
                  <td  align="center"><%=ht.get("CAR_NO")%></td>
                  <td  align="center"><%=ht.get("CAR_NM")%></td>
                  <td  align="center"><%=ht.get("FROM_COMP")%></td>                  
                  <td  align="center"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("FROM_DT")))%></td>
                  <td  align="center"><%=ht.get("TO_COMP")%></td>                  
                  <td  align="center"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("TO_DT")))%></td>
                  <td  align="center"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("START_DT")))%></td>
                  <td  align="center"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("END_DT")))%></td>
                </tr>
                <%	}%>
                <% 	if(cont_size == 0) { %>
                <tr> 
                  <td colspan=11 align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>
                <%	}%>
            </table>
        </td>
  </tr>
  <%	Vector vt2 = cdb.getFineRegConsList("cons_TMSG", car_mng_id, AddUtil.replace(vio_dt,"-",""));
			int cont_size2 = vt2.size();
	%>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>인도인수증 s-form</span></td>        
    </tr>    
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td rowspan='2' class=title width="50">연번</td>
                  <td rowspan='2' class=title width="100">계약번호</td>
                  <td rowspan='2' class=title width="120">상호</td>
                  <td rowspan='2' class=title width="80">차량번호</td>
                  <td rowspan='2' class=title width="120">차명</td>
                  <td colspan='4' class=title >탁송관리</td>
                  <td colspan='2' class=title >인도인수증</td>
                </tr>
                <tr>  
                  <td class=title width="150">출발지</td>
                  <td class=title width="90">출발일시</td>
                  <td class=title width="150">도착지</td>
                  <td class=title width="90">도착일시</td>
                  <td class=title width="50">파일</td>
                  <td class=title width="130">저장일시</td>
                </tr>
                <%  for(int i = 0 ; i < cont_size2 ; i++){
				              Hashtable ht = (Hashtable)vt2.elementAt(i);
				              String content = String.valueOf(ht.get("CONTENT"));
				              content = AddUtil.replace(String.valueOf(ht.get("CONTENT")), "\\","/");
				              content = content.substring(18); //D:\inetpub\wwwroot 정리
				        %>
                <tr> 
                  <td  align="center"><%=i+1%></td>
                  <td  align="center"><%=ht.get("RENT_L_CD")%></td>
                  <td  align="center"><%=ht.get("FIRM_NM")%></td>
                  <td  align="center"><%=ht.get("CAR_NO")%></td>
                  <td  align="center"><%=ht.get("CAR_NM")%></td>
                  <td  align="center"><%=ht.get("FROM_COMP")%></td>                  
                  <td  align="center"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("FROM_DT")))%></td>
                  <td  align="center"><%=ht.get("TO_COMP")%></td>                  
                  <td  align="center"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("TO_DT")))%></td>
                  <td  align="center">
                  	<a href="javascript:MM_openBrWindow('<%=content%>','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>                  	
                  </td>
                  <td  align="center"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("UPD_YMD"))+""+String.valueOf(ht.get("UPD_TIME")))%></td>
                </tr>
                <%	}%>
                <% 	if(cont_size == 0) { %>
                <tr> 
                  <td colspan=11 align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>
                <%	}%>
            </table>
        </td>
  </tr>
  <tr> 
        <td>&nbsp;</td>
  </tr>
  <tr>
        <td align="right"><a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border="0"></a></td>
  </tr>
</table>
</form>
</body>
</html>