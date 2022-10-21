<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	int total_su = 0;
	long total_amt = 0;
	
	
	
	AddForfeitDatabase afm_db = AddForfeitDatabase.getInstance();
	
	Vector vt = new Vector();
//	Vector vt = afm_db.getFineResCarList(gubun1, gubun2, s_kd, t_wd, sort_gubun, asc);
	int vt_size = vt.size();
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
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
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=vt_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1510'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='380' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
        			<td width="40" class='title'>연번</td>
        			<td width="150" class='title'>상호</td>				
        			<td width="90" class='title'>차량번호</td>
        			<td width="100" class='title'>차명</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='1130'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>		
                <tr> 
        			<td width="150" class='title'>위반일자</td>
        			<td width="100" class='title'>위반장소</td>					
        			<td width="100" class='title'>위반내용</td>
        			<td width="80" class='title'>납부방식</td>
        			<td width="80" class='title'>과실구분</td>
        			<td width="80" class='title'>금액</td>		  					
        			<td width="80" class='title'>대차구분</td>
        			<td width="150" class='title'>배차일시</td>			
        			<td width="150" class='title'>반차일시</td>
        			<td width="80" class='title'>등록자</td>
        			<td width="80" class='title'>등록일</td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
	    <td class='line' width='380' id='td_con' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for(int i = 0 ; i < vt_size ; i++){
    					Hashtable ht = (Hashtable)vt.elementAt(i);%>	
                <tr> 
        			<td width="40" align="center"><%=i+1%></td>
        			<td width="150" align="center"><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 10)%></span></td>				
        			<td width="90" align="center"><a href="javascript:parent.view_forfeit('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("SEQ_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CAR_NO")%></a></td>
        			<td width="100" align="center"><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span></td>
                </tr>
              <%		}%>
                <tr> 
                    <td colspan="4" class="title">&nbsp;</td>
                </tr>						  
            </table>
        </td>
	    <td class='line' width='1130'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for(int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);%>	
                <tr> 
        			<td width="150" align="center"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("VIO_DT")))%></td>
        		    <td width="100" align="center"><span title='<%=ht.get("VIO_PLA")%>'><%=Util.subData(String.valueOf(ht.get("VIO_PLA")), 6)%></span></td>
        		    <td width="100" align="center"><span title='<%=ht.get("VIO_CONT")%>'><%=Util.subData(String.valueOf(ht.get("VIO_CONT")), 6)%></span></td>
        		    <td width="80" align="center"><%=ht.get("PAID_ST_NM")%></td>
        		    <td width="80" align="center"><%=ht.get("FAULT_ST_NM")%></td>
        		    <td width="80" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("PAID_AMT")))%>원</td>						
        			<td width="80" align="center"><%=ht.get("RENT_ST")%></td>				  
        			<td width="150" align="center"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("DELI_DT")))%></td>
        			<td width="150" align="center"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("RET_DT")))%></td>
        			<td width="80" align="center"><%=ht.get("REG_NM")%></td>
        			<td width="80" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                </tr>
              <%	total_amt = total_amt  + Long.parseLong(String.valueOf(ht.get("PAID_AMT")));
    		}%>
                <tr> 
                    <td colspan="5" class="title">&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>원&nbsp;</td>			
                    <td colspan="5" class="title">&nbsp;</td>						
                </tr>			
            </table>
	    </td>
    </tr>
</table>
</form>
</body>
</html>
