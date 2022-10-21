<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = new Vector();
	vt = a_db.getContTaechaStatList(s_kd, t_wd, andor, gubun1, gubun2, gubun3, ck_acar_id);
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
<table border="0" cellspacing="0" cellpadding="0" width='1550'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='250' id='td_title' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='30' class='title' style='height:51'>연번</td>
                    <td width='100' class='title'>계약번호</td>
                    <td width="120" class='title'>고객</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='1300'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
                    <td colspan="5" class='title'>신차</td>
                    <td colspan="6" class='title'>출고지연대차</td>
        		    <td rowspan="2" width="70" class='title'>계약일자</td>		  
        		    <td rowspan="2" width="70" class='title'>최초영업자</td>		
                    <td colspan="4" class='title'>견적</td>					
        	    </tr>
        		<tr>
        		    <td width='80' class='title'>차량번호</td>
        		    <td width='80' class='title'>차종</td>
        		    <td width='80' class='title'>월대여료</td>
        		    <td width="80" class='title'>대여개시일</td>
        		    <td width="50" class='title'>스케줄</td>					
        	        <td width='80' class='title'>차량번호</td>
        	        <td width='80' class='title'>차종</td>
        	        <td width='90' class='title'>월대여료</td>
        	        <td width='80' class='title'>대여개시일</td>
        	        <td width='80' class='title'>대여만료일</td>					
        		    <td width="50" class='title'>스케줄</td>
        	        <td width='90' class='title'>정상대여료?/td>
        	        <td width='80' class='title'>대여개시일</td>
        	        <td width='80' class='title'>대여만료일</td>
        	        <td width='80' class='title'>계약대여료</td>					
        		</tr>
    	    </table>
	    </td>
    </tr>
  <%if(cont_size > 0){%>
    <tr>		
        <td class='line' width='250' id='td_con' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%	for(int i = 0 ; i < cont_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);
    				String td_color = "";
    				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";%>
                <tr> 
                    <td <%=td_color%> width='30' align='center'><%=i+1%></td>
                    <td <%=td_color%> width='100' align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>', '<%=ht.get("CAR_ST")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
                    <td <%=td_color%> width='120' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 8)%></span></td>
                </tr>
            <%		}	%>
            </table>
	    </td>
	    <td class='line' width='1300'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = " class=is ";%>
        		<tr>
        		    <td <%=td_color%> width='80' align='center'><%=ht.get("A_CAR_NO")%></td>				
        		    <td <%=td_color%> width='80' align='center'><span title='<%=ht.get("A_CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("A_CAR_NM")), 5)%></span></td>									
        		    <td <%=td_color%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>원</td>														
                    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>					
        		    <td <%=td_color%> width='50' align='center'><%=ht.get("A_SCD_CNT")%></td>														
        		    <td <%=td_color%> width='80' align='center'><%=ht.get("B_CAR_NO")%></td>				
        		    <td <%=td_color%> width='80' align='center'><span title='<%=ht.get("B_CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("B_CAR_NM")), 5)%></span></td>									
        		    <td <%=td_color%> width='90' align='right'>
					<%if(String.valueOf(ht.get("RENT_FEE")).equals("0") && String.valueOf(ht.get("REQ_ST")).equals("무상대차")){%>
					<font color='red'>무상대차</font>
					<%}else if(String.valueOf(ht.get("RENT_FEE")).equals("0") && !String.valueOf(ht.get("REQ_ST")).equals("무상대차") && String.valueOf(ht.get("TAE_ST")).equals("미발행")){%>
					<font color='red'>미발행</font>
					<%}else{%>
					<%if(String.valueOf(ht.get("REQ_ST")).equals("무상대차")){%>
					<span style="font-size : 6pt;"><font color='Fuchsia'>(무)</font></span>
					<%}%>
					<%if(!String.valueOf(ht.get("REQ_ST")).equals("무상대차") && String.valueOf(ht.get("TAE_ST")).equals("미발행")){%>
					<span style="font-size : 6pt;"><font color='Fuchsia'>(미)</font></span>
					<%}%>
					<%=Util.parseDecimal(String.valueOf(ht.get("RENT_FEE")))%>원
					<%}%>
					</td>																			
                    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_RENT_ST")))%></td>					
                    <td <%=td_color%> width='80' align='center'>
					<%if(!String.valueOf(ht.get("CAR_RENT_ET")).equals(String.valueOf(ht.get("T_RENT_END_DT")))){%>
					<font color='red'>
					<%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_RENT_ET")))%>
					</font>
					<%}else{%>
					<%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_RENT_ET")))%>
					<%}%>
					</td>
        		    <td <%=td_color%> width='50' align='center'><%=ht.get("B_SCD_CNT")%></td>														
                    <td <%=td_color%> width='70' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>										
        		    <td <%=td_color%> width='70' align='center'><%=ht.get("USER_NM")%></td>		  
                    <td <%=td_color%> width='90' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("RENT_INV")))%>원</td>															
                    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("T_RENT_START_DT")))%></td>					
                    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("T_RENT_END_DT")))%></td>										
                    <td <%=td_color%> width='80' align='right'>
					<%if(!String.valueOf(ht.get("T_FEE_AMT")).equals(String.valueOf(ht.get("RENT_FEE")))){%>
					<font color='red'>
					<%=Util.parseDecimal(String.valueOf(ht.get("T_FEE_AMT")))%>원
					</font>
					<%}else{%>
					<%=Util.parseDecimal(String.valueOf(ht.get("T_FEE_AMT")))%>원
					<%}%>
					</td>
        		</tr>
<%		}	%>
          </table>
	    </td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='250' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'><%if(t_wd.equals("")){%>검색어를 입력하십시오.<%}else{%>등록된 데이타가 없습니다<%}%></td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='1300'>			
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


