<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.parts.*"%>
<jsp:useBean id="p_db" scope="page" class="acar.parts.PartsDatabase"/>
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
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
	
	function DocPrint(reqseq, car_mng_id, ch_dt){
		var fm = document.form1;
		var SUBWIN="doc_print.jsp?ch_dt="+ch_dt+"&reqseq="+ reqseq + "&car_mng_id="+ car_mng_id;	
		window.open(SUBWIN, "DocPrint", "left=50, top=50, width=700, height=600, scrollbars=yes, status=yes");
	}
		
	
			
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_gubun1 = request.getParameter("s_gubun1")==null?"1":request.getParameter("s_gubun1");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
		
	Vector vt = p_db.getPartsChulgoPrintList( s_gubun1, st_dt, end_dt, s_kd,  t_wd,  sort, asc);
	int vt_size = vt.size();
	
	String item2 = "";
	
	long item_s_amt1 = 0;
	
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='vt_size' value='<%=vt_size%>'>


<table width="1030" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
 	  <td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width='1030'>
	       <tr> 
                            <td width='60' class='title' >연번</td>
                             <td width='80' class='title' >출고일</td>
                            <td width='90' class='title' >차량번호</td>
                            <td width='120' class='title' >차명</td>
                            <td width='180' class='title' >거래처명</td>
                            <td width='100' class='title' >담당자</td>
                           <td width='100' class='title' >공급가</td>
                            <td width='120' class='title'>정비업체</td>
                    </tr>
              
            </table>
        </td>
    </tr>     
    <tr>
         	  <td class='line' width='1030' > 
         	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            	    
              <%if(vt_size > 0){
				for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);	
							
							item_s_amt1 = item_s_amt1 +  Long.parseLong(String.valueOf(ht.get("R_S_AMT")));
													
				%>
          <tr> 
            <td  width='60' align="center"><%=i+1%></td>
             <td  width='80'   align="center"><%=ht.get("CH_DT")%></td>	     
             <td width='90'  align="center"> <a href="javascript:DocPrint('<%=ht.get("REQSEQ")%>',  '<%=ht.get("CAR_MNG_ID")%>' ,  '<%=ht.get("CH_DT")%>' );"><%=ht.get("CAR_NO")%></a></td>
            <td  width='120'   align="center"><%=ht.get("CAR_NM")%></td>	         
            <td  width='180'  align="center"><%=ht.get("FIRM_NM")%></td>		
             <td width='100'   align="center"><%=ht.get("USER_NM")%></td>	
             <td width='100'   align="right"><%=Util.parseDecimal(String.valueOf(ht.get("R_S_AMT")))%></td>	
              <td width='120'   align="center"><%=ht.get("OFF_NM")%></td>		                     						
          </tr>
          
                <%		}%> 	
	
	  <tr> 
		   <td  height="22" colspan="6"  class='title' >합계</td>	
	             <td width='100'   align="right"><%=Util.parseDecimal(item_s_amt1)%></td>	
	             <td width='120'   align="center"></td>	
           </tr>
                            
<%	}else{%>                     
      
                      <tr> 
                        <td align='center' colspan=8>등록된 데이타가 없습니다</td>
                      </tr>
  
   <% }%>          			  
       </table>
      </td>
 </tr>	  	
</table>
<script language='javascript'>
<!--

-->
</script>
 </td>
    </tr>
</table>
</form>
</body>
</html>
