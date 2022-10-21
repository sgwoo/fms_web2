<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = new Vector();
	
	//if(!t_wd.equals("")){
		vt = a_db.getContBcClsList(s_kd, t_wd, andor, gubun1, gubun2, gubun3);
	//}
	int cont_size = vt.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='1530'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='26%' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='8%' class='title' style='height:34'>연번</td>
                    <td width='8%' class='title'>구분</td>
        		    <td width="8%" class='title'>견적</td>
                    <td width='15%' class='title'>최초영업자</td>
                    <td width="25%" class='title'>계약번호</td>
                    <td width="36%" class='title'>고객</td>					
                </tr>
            </table>
    	</td>
	    <td class='line' width='74%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
        		    <td width="10%" class='title' style='height:34'>차종</td>
        		    <td width="7%" class='title'>차량번호</td>
        	        <td width='6%' class='title'>차량<br>구분</td>		  
        	        <td width='5%' class='title'>계약<br>구분</td>
        	        <td width='5%' class='title'>용도<br>구분</td>
        	        <td width='5%' class='title'>관리<br>구분</td>		  
        	        <td width='4%' class='title'>약정<br>기간</td>
        	        <td width='7%' class='title'>해지일자</td>		  
        	        <td width='7%' class='title'>견적일자</td>		  
        	        <td width='7%' class='title'>대여개시일</td>
        	        <td width='7%' class='title'>적용<br>신용등급</td>
        		    <td width='6%' class='title'>견적대여료</td>
        		    <td width='6%' class='title'>기준대여료<br>(c)</td>
        		    <td width='6%' class='title'>정상대여료<br>(g)</td>
        		    <td width='6%' class='title'>계약대여료<br>(h)</td>
        		    <td width='6%' class='title'>등록자</td>
        		</tr>
	        </table>
	    </td>
    </tr>
  <%if(cont_size > 0){%>
    <tr>		
        <td class='line' width='26%' id='td_con' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%	for(int i = 0 ; i < cont_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);
    				String td_color = "";
    				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";
    				
    				if(AddUtil.parseInt(String.valueOf(ht.get("CON_MON"))) < 0 ) continue;
    				
    				count++;
    	    %>
                <tr> 
                    <td <%=td_color%> width='8%' align='center'><%=count%></td>
                    <td <%=td_color%> width='8%' align='center'><%=ht.get("USE_YN")%></td>		  
        		    <td <%=td_color%> width='8%' align='center'><%=ht.get("BC_EST_YN")%></td>		  
        		    <td <%=td_color%> width='15%' align='center'><%=ht.get("USER_NM")%></td>		  		  
                    <td <%=td_color%> width='25%' align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("RENT_ST")%>', 's')" onMouseOver="window.status=''; return true" title='계약약식내역'><%=ht.get("RENT_L_CD")%></a></td>		  
        		    <td <%=td_color%> width='36%' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 9)%></span></td>		  		  					
                </tr>
                <%		}	%>
            </table>
    	</td>
	    <td class='line' width='74%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = " class=is ";
				
				if(AddUtil.parseInt(String.valueOf(ht.get("CON_MON"))) < 0 ) continue;
		%>
                <tr>
        		    <td <%=td_color%> width='10%' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 8)%></span></td>
        		    <td <%=td_color%> width='7%' align='center'><%=ht.get("CAR_NO")%></td>					
        		    <td <%=td_color%> width='6%' align='center'><%=ht.get("CAR_GU")%></td>
        		    <td <%=td_color%> width='5%' align='center'><%=ht.get("CONT_ST")%></td>		  		  
        		    <td <%=td_color%> width='5%' align='center'><%=ht.get("CAR_ST")%>(<%=ht.get("RENT_ST")%>)</td>
        		    <td <%=td_color%> width='5%' align='center'><%=ht.get("RENT_WAY")%></td>	
        		    <td <%=td_color%> width='4%' align='center'><%=ht.get("CON_MON")%></td>
        		    <td <%=td_color%> width='7%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>		  
        		    <td <%=td_color%> width='7%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>		  
        		    <td <%=td_color%> width='7%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
        		    <td <%=td_color%> width='7%' align='center'><%=ht.get("SPR_KD")%></td>
        		    <td <%=td_color%> width='6%' align='right'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("RENT_ST")%>', 's')" onMouseOver="window.status=''; return true" title='계약약식내역'><%=Util.parseDecimal(String.valueOf(ht.get("INV_S_AMT")))%>원</a></td>		  
        		    <td <%=td_color%> width='6%' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("BC_S_C")))%>원</td>
        		    <td <%=td_color%> width='6%' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("BC_S_G")))%>원</td>
        		    <td <%=td_color%> width='6%' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>원</td>
        		    <td <%=td_color%> width='6%' align='center'><%=ht.get("REG_ID")%></td>
        		</tr>
<%		}	%>
	        </table>
	    </td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='26%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'><%if(t_wd.equals("")){%>검색어를 입력하십시오.<%}else{%>등록된 데이타가 없습니다<%}%></td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='74%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td>&nbsp;</td>
		        </tr>
  	        </table>
	    </td>
    </tr>
<%	}	%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=cont_size%>';
//-->
</script>
</body>
</html>


