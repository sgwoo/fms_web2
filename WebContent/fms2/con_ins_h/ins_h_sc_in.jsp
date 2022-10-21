<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_accident.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
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
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	String rent="";
	int total_su = 0;
	long total_amt = 0;	
	long total_amt2 = 0;	
	long total_amt3 = 0;	
	long total_amt4 = 0;	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarAccidDatabase a_cad = AddCarAccidDatabase.getInstance();
	
	Vector ins_hs = ae_db.getInsurHList(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int ins_h_size = ins_hs.size();
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=ins_h_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1710'>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='500' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>					
                    <td width=100 class='title'>연번</td>					
                    <td width=60 class='title'>구분</td>
        		    <td width=100 class='title'>계약번호</td>
        		    <td width=150 class='title'>상호</td>
        		    <td width=90 class='title'>차량번호</td>
		        </tr>
	        </table>
	    </td>
	    <td class='line' width='1210'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=150 class='title'>차명</td>
                    <td width=80 class='title'>계약일</td>
                    <td width=70 class='title'>사고구분</td>
                    <td width=80 class='title'>사고일자</td>
               <!--     <td width=80 class='title'>보험회사</td> -->
                    <td width=80 class='title'>청구구분</td>					
                    <td width=100 class='title'>보험사</td>
                    <td width=80 class='title'>청구금액</td>
                    <td width=80 class='title'>청구일자</td>
                    <td width=100 class='title'>입금구분</td>										
                    <td width=80 class='title'>입금액</td>
                    <td width=80 class='title'>차액</td>
                    <td width=90 class='title'>계산서일자</td>					
                    <td width=80 class='title'>수금일자</td>
                    <td width=60 class='title'>담당자</td>
                </tr>
            </table>
	    </td>
    </tr>
<%	if(ins_h_size > 0){%>
    <tr>
	    <td class='line' width='500' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%		for (int i = 0 ; i < ins_h_size ; i++){
			Hashtable ins_h = (Hashtable)ins_hs.elementAt(i);
			String tm_st= "3";
			if(String.valueOf(ins_h.get("CAR_NO")).substring(4,5).equals("허")) tm_st = "2";%>
                <tr> 
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=100 align='center'><a name="<%=i+1%>"><%=i+1%>
                      <%if(ins_h.get("USE_YN").equals("N")){%>
                      (해약)
                      <%}%>
                      </a></td>
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=60 align='center'><a href="javascript:parent.view_memo('<%=ins_h.get("RENT_MNG_ID")%>','<%=ins_h.get("RENT_L_CD")%>','<%=ins_h.get("CAR_MNG_ID")%>','<%=ins_h.get("CAR_NO")%>','<%=ins_h.get("ACCID_ID")%>','<%=ins_h.get("MNG_ID")%>')" onMouseOver="window.status=''; return true" title="<%=a_cad.getMaxMemo(String.valueOf(ins_h.get("RENT_MNG_ID")), String.valueOf(ins_h.get("RENT_L_CD")), tm_st, String.valueOf(ins_h.get("ACCID_ID")), "")%>"><%=ins_h.get("GUBUN")%></a></td>
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=100 align='center'><a href="javascript:parent.view_ins_h('<%=ins_h.get("RENT_MNG_ID")%>','<%=ins_h.get("RENT_L_CD")%>','<%=ins_h.get("CAR_MNG_ID")%>','<%=ins_h.get("ACCID_ID")%>', '<%=ins_h.get("SEQ_NO")%>', '<%=ins_h.get("EXT_ID")%>',  '<%=i%>')" onMouseOver="window.status=''; return true"><%=ins_h.get("RENT_L_CD")%></a></td>
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=150 align='center'><span title='<%=ins_h.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=ins_h.get("RENT_MNG_ID")%>','<%=ins_h.get("RENT_L_CD")%>','<%=ins_h.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(ins_h.get("FIRM_NM")), 7)%></a></span></td>
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=90 align='center'><span title='<%=ins_h.get("CAR_NO")%>'><%=Util.subData(String.valueOf(ins_h.get("CAR_NO")), 15)%></span></td>
                </tr>
                <%	}%>		  
                <tr> 
                    <td class="title" align='center'></td>		  
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title" align='center'>합계</td>			
                    <td class="title">&nbsp;</td>			
                </tr>
            </table>
	    </td>
	    <td class='line' width='1210'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%		for (int i = 0 ; i < ins_h_size ; i++){
    			Hashtable ins_h = (Hashtable)ins_hs.elementAt(i);
    			
    			if ( AddUtil.parseLong(String.valueOf(ins_h.get("PAY_AMT"))) > 0) { 
    				total_amt3 = AddUtil.parseLong(String.valueOf(ins_h.get("REQ_AMT"))) - AddUtil.parseLong(String.valueOf(ins_h.get("PAY_AMT")));
    			 }
    			
    %>
                <tr> 
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=150 align='center'><span title='<%=ins_h.get("CAR_NM")%> <%=ins_h.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(ins_h.get("CAR_NM"))+" "+String.valueOf(ins_h.get("CAR_NAME")), 9)%></span></td>
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=80 align='center'><%=ins_h.get("RENT_DT2")%></td>
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=70 align='center'><%=ins_h.get("ACCID_ST")%></td>
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=80 align='center'><%=ins_h.get("ACCID_DT")%></td>           
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=80 align='center'><%=ins_h.get("REQ_GU")%></td>					
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=100 align='center'><span title='<%=ins_h.get("OT_INS2")%>'><%=Util.subData(String.valueOf(ins_h.get("OT_INS2")), 6)%></span></td>
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=80 align='right'><%=Util.parseDecimal(String.valueOf(ins_h.get("REQ_AMT")))%></td>						
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=80 align='center'><%=ins_h.get("REQ_DT")%></td>
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=100 align='center'><%=ins_h.get("REQ_GU")%><%if(!String.valueOf(ins_h.get("EXT_TM")).equals("1")){%>&nbsp;잔액<%}%></td>		
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=80 align='right'><%=Util.parseDecimal(String.valueOf(ins_h.get("PAY_AMT")))%></td>		
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=80 align='right'><%=Util.parseDecimal(total_amt3)%></td>	
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=90 align='center'><%=ins_h.get("EXT_DT")%></td>					
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=80 align='center'><%=ins_h.get("PAY_DT")%></td>
                    <td <%if(ins_h.get("USE_YN").equals("N")){%>class='is'<%}%> width=60 align='center'><%=c_db.getNameById(String.valueOf(ins_h.get("BUS_ID2")),"USER")%></td>
                    
                </tr>
              <%
    				total_su = total_su + 1;
    				total_amt = total_amt + AddUtil.parseLong(String.valueOf(ins_h.get("REQ_AMT")));
    				total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ins_h.get("PAY_AMT")));
    				total_amt4 = total_amt4 + total_amt3;
    		  		}%>		  
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>			
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>					
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>			
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>			
                    <td class="title">&nbsp;</td>	
                    <td class="title">&nbsp;</td>						
                    <td class="title">&nbsp;</td>			
                </tr>
            </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td class='line' width='500' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td align='center'>등록된 데이타가 없습니다</td>
		        </tr>
	        </table>
	    </td>
	    <td class='line' width='1210'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td>&nbsp;</td>
		        </tr>
	        </table>
	    </td>
    </tr>
<% 	}%>
</table>
</form>
</body>
</html>
