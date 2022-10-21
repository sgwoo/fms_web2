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
		vt = a_db.getContCashBackList(s_kd, t_wd, andor, gubun1, gubun2, gubun3);
	//}
	int cont_size = vt.size();
	
	long total_amt1 	= 0;
	long total_amt2 	= 0;
	long total_amt3 	= 0;
	long total_amt4 	= 0;
	long total_amt5 	= 0;
	long total_amt6 	= 0;
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
<table border="0" cellspacing="0" cellpadding="0" width='1690'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='480' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                  <td width='40' class='title'  style='height:51'>연번</td>
                  <td width='100' class='title'>계약번호</td>
                  <td width='80' class='title'>계약일자</td>
                  <td width="170" class='title'>고객</td>
                  <td width='80' class='title'>대여개시일</td>                  
                </tr>
            </table>
    	</td>
	    <td class='line' width='1220'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        	    <tr>
                          <td colspan="4" class='title'>자동차</td>                  
                          <td colspan="3" class='title'>차량가격</td>
        		  <td colspan="4" class='title'>캐쉬백</td>        		  
        		  <td rowspan="2" width='50' class='title'>최초<br>영업자</td>
        		  <td rowspan="2" width='70' class='title'>출고<br>영업사원</td>
        	    </tr>
        	    <tr>
        		  <td width="130" class='title'>제조사</td>
        		  <td width="100" class='title'>출고영업소</td>
        		  <td width="130" class='title'>차종</td>
        		  <td width="80" class='title'>차량번호</td>
        		  
        	          <td width='100' class='title'>소비자가</td>
        	          <td width='100' class='title'>매출D/C</td>
        	          <td width='100' class='title'>카드결재금액</td>

        	          <td width='100' class='title'>약정금액</td>
        	          <td width='100' class='title'>수금금액</td>
        	          <td width='80' class='title'>차액</td>
        	          <td width='80' class='title'>수금일자</td>
        	    </tr>
	        </table>
	    </td>
    </tr>
  <%if(cont_size > 0){%>
    <tr>		
        <td class='line' width='480' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";
    				%>
                <tr> 
                  <td <%=td_color%> width='40' align='center'><%=i+1%></td>
                  <td <%=td_color%> width='100' align='center'><%=ht.get("RENT_L_CD")%></td>
                  <td <%=td_color%> width='80' align='center'>
                      <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%>
                  </td>
                  <td <%=td_color%> width='170' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 13)%></span></td>
                  <td <%=td_color%> width='80' align='center'>
                      <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%>
                  </td>
                </tr>
        <%		}	%>
                <tr> 
                    <td class="title" align='center' colspan='5'>합계</td>
                </tr>        
            </table>
	    </td>
	    <td class='line' width='1220'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = " class=is ";
				total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CAR_C_AMT")));
				total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("DC_AMT")));
				total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("IMPORT_CARD_AMT")));
				total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("IMPORT_CASH_BACK")));
				total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("R_IMPORT_CASH_BACK")));
				total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("CASH_BACK_CHA_AMT")));
				%>
        		<tr>
        		  <td <%=td_color%> width='130' align='center'><span title='<%=ht.get("CAR_COMP_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_COMP_NM")), 12)%></span></td>
        		  <td <%=td_color%> width='100' align='center'><span title='<%=ht.get("CAR_OFF_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_OFF_NM")), 7)%></span></td>
        		  <td <%=td_color%> width='130' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>
        		  <td <%=td_color%> width='80' align='center'><%=ht.get("CAR_NO")%></td>					
        		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("CAR_C_AMT")))%></td>
        		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("DC_AMT")))%></td>
        		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("IMPORT_CARD_AMT")))%></td>
        		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("IMPORT_CASH_BACK")))%></td>
        		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("R_IMPORT_CASH_BACK")))%></td>
        		  <td <%=td_color%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("CASH_BACK_CHA_AMT")))%></td>
        		  <td <%=td_color%> width='80' align='center'>
        		      <%if(!String.valueOf(ht.get("CASH_BACK_PAY_DT")).equals("")){%>
        		          <a href="javascript:parent.reg_pay_dt('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CASH_BACK_PAY_DT")))%></a>
        		      <%}else{%>
        		          <a href="javascript:parent.reg_pay_dt('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');" class="btn"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
        		      <%}%>
        		  </td>
        		  <td <%=td_color%> width='50' align='center'><%=ht.get("USER_NM")%></td>
        		  <td <%=td_color%> width='70' align='center'><span title='<%=ht.get("EMP_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("EMP_NM")), 4)%></span></td>
        		</tr>
<%		}	%>
                <tr> 
                    <td class="title" colspan='4'>&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt5)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt6)%></td>
                    <td class="title" colspan='3'>&nbsp;</td>
                </tr>
	        </table>
	    </td>
<%	}else{	%>
    <tr>		
        <td class='line' width='480' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'><%if(t_wd.equals("")){%>검색어를 입력하십시오.<%}else{%>등록된 데이타가 없습니다<%}%></td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='1220'>
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


