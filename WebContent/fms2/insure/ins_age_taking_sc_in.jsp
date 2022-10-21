<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String print_yn = request.getParameter("print_yn")==null?"":request.getParameter("print_yn");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector vt = ai_db.getInsureStatSearchList("ins_age_taking");
	int vt_size = vt.size();
	
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//프린트하기
	function stat_print(){
		window.open("ins_age_taking_sc_in.jsp?print_yn=Y","print","left=30,top=50,width=950,height=600,scrollbars=yes");	
	}
	
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%if(print_yn.equals("Y")){%>
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,4,438,06"> 
</object> 
<%}%>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업용</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class='line' width='100%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='40%' class='title'>승차정원</td>
		    <td width='20%' class='title'>연령범위</td>
		    <td width='40%' class='title'>건수</td>				
		</tr>    
	    </table>
	</td>
    </tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='100%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			count 	= count + AddUtil.parseInt(String.valueOf(ht.get("CNT")));

%>
				<tr>
					<td width='40%' align='center'><%if(String.valueOf(ht.get("TAKING")).equals("0")){%>6인승<%}else{%>다인승<%}%></td>
					<td width='20%' align='center'>
					    <!--<%if(String.valueOf(ht.get("AGE")).equals("0")){%>21세이상<%}else{%>26세이상<%}%>-->
					    <%if(String.valueOf(ht.get("AGE")).equals("1")){%>21세이상
					    <%}else if(String.valueOf(ht.get("AGE")).equals("4")){%>24세이상
					    <%}else if(String.valueOf(ht.get("AGE")).equals("2")){%>26세이상
					    <%}else if(String.valueOf(ht.get("AGE")).equals("3")){%>전연령
					    <%}else if(String.valueOf(ht.get("AGE")).equals("5")){%>30세이상
					    <%}else if(String.valueOf(ht.get("AGE")).equals("6")){%>35세이상
					    <%}else if(String.valueOf(ht.get("AGE")).equals("7")){%>43세이상
					    <%}else if(String.valueOf(ht.get("AGE")).equals("8")){%>48세이상
					    <%}%>
					</td>
					<td width='40%' align='right'><%=ht.get("CNT")%></td>
				</tr>
<%
		}
%>
                <tr> 
                    <td class="title" colspan='2'>합계</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(count)%></td>
                </tr>	
			</table>
		</td>
    </tr>		
		
<%                     
	}                  
%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>업무용</span></td>
    </tr>
    
    
    <%		vt = ai_db.getInsureStatSearchList("ins_age_taking2");
		vt_size = vt.size();
		count =0;
    %>    
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class='line' width='100%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='20%' class='title'>차종분류</td>
		    <td width='20%' class='title'>승차정원</td>
		    <td width='20%' class='title'>연령범위</td>
		    <td width='40%' class='title'>건수</td>				
		</tr>    
	    </table>
	</td>
    </tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='100%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			count 	= count + AddUtil.parseInt(String.valueOf(ht.get("CNT")));

%>
				<tr>
					<td width='20%' align='center'><%=ht.get("S_ST")%></td>
					<td width='20%' align='center'><%if(String.valueOf(ht.get("S_ST")).equals("승용")){%><%if(String.valueOf(ht.get("TAKING")).equals("0")){%>6인승<%}else{%>다인승<%}%><%}%></td>
					<td width='20%' align='center'><%=ht.get("AGE")%></td>					
					<td width='40%' align='right'><%=ht.get("CNT")%></td>
				</tr>
<%
		}
%>
                <tr> 
                    <td class="title" colspan='3'>합계</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(count)%></td>
                </tr>	
			</table>
		</td>
    </tr>		
		
<%                     
	}                  
%>
    <%if(!print_yn.equals("Y")){%>
    <tr>
        <td align='right'>
           <a href='javascript:stat_print()' title='프린트하기'><img src=/acar/images/center/button_print.gif align=absmiddle border=0></a> 
            </td>
    </tr>       
    <%}%>
</table>
<script language='javascript'>
<!--
<%if(print_yn.equals("Y")){%>
onprint();

function onprint(){
	factory.printing.header 	= ""; //폐이지상단 인쇄
	factory.printing.footer 	= ""; //폐이지하단 인쇄
	factory.printing.portrait 	= false; //true-세로인쇄, false-가로인쇄    
	factory.printing.leftMargin 	= 10.0; //좌측여백   
	factory.printing.rightMargin 	= 10.0; //우측여백
	factory.printing.topMargin 	= 10.0; //상단여백    
	factory.printing.bottomMargin 	= 10.0; //하단여백
	factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
<%}%>	
//-->
</script>
</body>
</html>
