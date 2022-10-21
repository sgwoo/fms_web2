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
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acct/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �뿩��������Cycle > <span class=style5>�����԰�ǻ�Ȯ��</span></span></td>
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
              <!--���رⰣ-->
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acct/images/center/arrow_gjij.gif align=absmiddle>
	      <%=AddUtil.ChangeDate2(st_dt)%>
              ~ 
              <%=AddUtil.ChangeDate2(end_dt)%>
              <!--���ü�-->
              &nbsp;&nbsp;&nbsp;&nbsp;
              <img src=/acct/images/center/arrow_nsp.gif align=absmiddle> 
              <%=s_cnt%>��
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
      	<%=AddUtil.getDate()%> ����
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
	    <td class="title" width="25%">��¥</td>
	    <td class="title" width="70%">Ȯ������</td>
	    <!--<td class="title" width="10%">��</td>-->
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
	    <td>Test ��� (���ܻ��� �� <%//=exception_cnt%> / ���� �� <%=size%>)</td>
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
factory.printing.header 	= ""; 		//��������� �μ�
factory.printing.footer 	= ""; 		//�������ϴ� �μ�
factory.printing.portrait 	= false; 	//true-�����μ�, false-�����μ�    
factory.printing.leftMargin 	= 20.0; 	//��������   
factory.printing.rightMargin 	= 20.0; 	//��������
factory.printing.topMargin 	= 20.0; 	//��ܿ���    
factory.printing.bottomMargin 	= 20.0; 	//�ϴܿ���
factory.printing.Print(true, window);		//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
//-->
</script>
</body>
</html>