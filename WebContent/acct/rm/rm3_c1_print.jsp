<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acct.* "%>
<%@ include file="/acct/cookies.jsp" %>

<%	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?"":request.getParameter("br_id");


	String st_dt 	= request.getParameter("st_dt")	 ==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt") ==null?"":request.getParameter("end_dt");
	String s_cnt 	= request.getParameter("s_cnt")  ==null?"":request.getParameter("s_cnt");

	int size 	= request.getParameter("size")	 	==null?0:AddUtil.parseDigit(request.getParameter("size"));
	int exception_cnt = request.getParameter("exception_cnt")==null?0:AddUtil.parseDigit(request.getParameter("exception_cnt"));	
	

	String seq[]  = request.getParameterValues("seq");
	String value1[]  = request.getParameterValues("value1");
	String value2[]  = request.getParameterValues("value2");
	String value3[]  = request.getParameterValues("value3");
	String value4[]  = request.getParameterValues("value4");
	String value5[]  = request.getParameterValues("value5");
	String value6[]  = request.getParameterValues("value6");
	String value7[]  = request.getParameterValues("value7");
	String value8[]  = request.getParameterValues("value8");
	String value9[]  = request.getParameterValues("value9");
	String value10[] = request.getParameterValues("value10");
	String value11[] = request.getParameterValues("value11");
	String value12[] = request.getParameterValues("value12");
	String value13[] = request.getParameterValues("value13");
	String value14[] = request.getParameterValues("value14");
	String value15[] = request.getParameterValues("value15");
	String value16[] = request.getParameterValues("value16");
	String value17[] = request.getParameterValues("value17");
	String value18[] = request.getParameterValues("value18");
	String value19[] = request.getParameterValues("value19");	
	String value20[] = request.getParameterValues("value20");	
	String result[]  = request.getParameterValues("result");

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/acct/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
//-->
</script>
</head>

<body leftmargin="15" onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,3,439,30">
</object>
<form name="form1" method="post" action="">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>
        <table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acct/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acct/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>내부통제 > 대여차량관리Cycle > <span class=style5>차량입고실사확인</span></span></td>
            <td width=7><img src=/acct/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td>
        <table border=0 cellspacing=1>
          <tr> 
            <td>
              <!--기준기간-->
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acct/images/center/arrow_gjij.gif align=absmiddle>
	      <%=AddUtil.ChangeDate2(st_dt)%>
              ~ 
              <%=AddUtil.ChangeDate2(end_dt)%>
              <!--샘플수-->
              &nbsp;&nbsp;&nbsp;&nbsp;
              <img src=/acct/images/center/arrow_nsp.gif align=absmiddle> 
              <%=s_cnt%>개
	    </td>
          </tr>
        </table>
      </td>
    </tr>  
    <tr>
      <td class=h></td>
    </tr>      
    <tr>
      <td align="right">
      	<%=AddUtil.getDate()%> 현재
      </td>
    </tr>      
    <tr>
      <td class=line2></td>
    </tr>  
    <tr>
      <td class='line'>
	<table border="0" cellspacing="1" cellpadding="0" width="100%">
	  <tr>
	    <td class="title" width="5%">No.</td>
	    <td class="title" width="25%">날짜</td>
	    <td class="title" width="70%">확인유무</td>
	    <!--<td class="title" width="10%">평가</td>-->
	  </tr>
	  <%	for(int i = 0 ; i < size ; i++){%>
	  <tr>
	    <td align="center"><%=seq[i]%></td>
	    <td align="center"><%=value1[i]%></td>            
	    <td align="center">&nbsp;<%=value2[i]%></td>            
	    <!--<td align='center'>&nbsp;</td>-->
	  </tr>
	  <%	}%>
	  <%	for(int i = size ; i < AddUtil.parseDigit(s_cnt) ; i++){%>
	  <tr>
	    <td align="center"><%=i+1%></td>
	    <td align="center"><%=value1[i]%></td>            
	    <td align="center">&nbsp;<%=value2[i]%></td>            
	    <!--<td align='center'>&nbsp;</td>-->
	  </tr>
	  <%	}%>	  
	</table>
      </td>
    </tr>
    <tr>
      <td class=h ></td>
    </tr>
    <tr>
      <td class='line'>
	<table border="0" cellspacing="1" cellpadding="0" width="100%">
	  <tr>
	    <td>Test 결과 (예외사항 수 <%//=exception_cnt%> / 샘플 수 <%=size%>)</td>
	  </tr>
	</table>
      </td>
    </tr>
    <tr>
      <td class=h ></td>
    </tr>    
  </table>
</form>
<script language='javascript'>
<!--
function onprint(){
factory.printing.header 	= ""; 		//폐이지상단 인쇄
factory.printing.footer 	= ""; 		//폐이지하단 인쇄
factory.printing.portrait 	= false; 	//true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin 	= 20.0; 	//좌측여백   
factory.printing.rightMargin 	= 20.0; 	//우측여백
factory.printing.topMargin 	= 20.0; 	//상단여백    
factory.printing.bottomMargin 	= 20.0; 	//하단여백
factory.printing.Print(true, window);		//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
//-->
</script>
</body>
</html>