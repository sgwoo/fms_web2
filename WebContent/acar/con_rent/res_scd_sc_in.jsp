<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
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

	function RentMemo(s_cd, c_id, user_id){
		var SUBWIN="./res_memo_i.jsp?s_cd="+s_cd+"&c_id="+c_id+"&user_id="+user_id;	
		window.open(SUBWIN, "RentMemoDisp", "left=50, top=50, width=580, height=700, scrollbars=yes");
	}	

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"6":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String brch_id = request.getParameter("s_brch")==null?"":request.getParameter("s_brch");
	String s_bus = request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String rent="";
	int total_su = 0;
	long total_amt = 0;	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector clss = rs_db.getScdRentMngList_New2(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, brch_id, s_bus, sort_gubun, asc);
	int cls_size = clss.size();
%>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=cls_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1610'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='520' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='40' class='title'>연번</td>
                    <td width='60' class='title'>구분</td>
                    <td width='70' class='title'>계약번호</td>
                    <td width='100' class='title'>성명</td>
                    <td width='150' class='title'>상호</td>
                    <td class='title' width="100">차량번호</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='1090'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='150' class='title'>차명</td>
                    <td width='80' class='title'>계약일자</td>
                    <td width='80' class='title'>계약구분</td>
                    <td width='80' class='title'>사용구분</td>			
                    <td width='80' class='title'>정산구분</td>			
                    <td width='80' class='title'>배차일자</td>
                    <td width='80' class='title'>반차일자</td>
                    <td width='80' class='title'>정산일자</td>
                    <td width='80' class='title'>대여요금</td>
                    <td width='80' class='title'>정산금액</td>
                    <td width='80' class='title'>입금금액</td>			
                    <td class='title' width='70'>최초영업자</td>
                    <td class='title' width='70'>관리담당자</td>
                </tr>
            </table>
	    </td>
    </tr>
<%	if(cls_size > 0){%>
    <tr>
    	<td class='line' width='520' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%		for (int i = 0 ; i < cls_size ; i++){
    			Hashtable cls = (Hashtable)clss.elementAt(i);
    			//연체료 셋팅
    			boolean flag = rs_db.calDelay((String)cls.get("RENT_S_CD"));%>
                <tr> 
                    <td width='40' align='center'><%=i+1%></td>
                    <td width='60' align='center'><a href="javascript:RentMemo('<%=cls.get("RENT_S_CD")%>','<%=cls.get("CAR_MNG_ID")%>','<%=user_id%>')"><font color='red'><%=cls.get("REG_YN")%></font></a></td>
                    <td width='70' align='center'><a href="javascript:parent.view_rent('<%=cls.get("RENT_S_CD")%>','<%=cls.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=cls.get("RENT_S_CD")%></a></td>
                    <td width='100' align='center'><span title='<%=cls.get("CUST_NM")%>'><%=Util.subData(String.valueOf(cls.get("CUST_NM")), 6)%></span></td><!--<a href="javascript:parent.view_cust('<%=cls.get("RENT_S_CD")%>','<%=cls.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"></a>-->
                    <td width='150' align='center'><span title='<%=cls.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(cls.get("FIRM_NM")), 7)%></span></td>
                    <td width="100" align='center'><span title='<%=cls.get("CAR_NO")%>'><%=cls.get("CAR_NO")%></span></td>
                </tr>
              <%
    				total_su = total_su + 1;
    				total_amt = total_amt + AddUtil.parseLong(String.valueOf(cls.get("PAY_AMT")));
    		  		}%>
                <tr> 
                    <td class='title'>합계</td>
                    <td class='title'>건수</td>
                    <td class='title'><%=total_su%>건</td>
                    <td class='title' colspan="2">금액</td>
                    <td class='title'><%=Util.parseDecimal(total_amt)%>원</td>
                </tr>
            </table>
    	</td>
	    <td class='line' width='1090'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%		for (int i = 0 ; i < cls_size ; i++){
    			Hashtable cls = (Hashtable)clss.elementAt(i);%>
                <tr> 
                    <td width='150' align='center'><span title='<%=cls.get("CAR_NM")%>'><%=Util.subData(String.valueOf(cls.get("CAR_NM")), 9)%></span></td>
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(cls.get("RENT_DT")))%></td>
                    <td width='80' align='center'><%=cls.get("RENT_ST")%></td>			
                    <td width='80' align='center'><%=cls.get("USE_ST")%></td>						
                    <td width='80' align='center'><%=cls.get("SETTLE_YN")%></td>						
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(cls.get("DELI_DT")))%></td>
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(cls.get("RET_DT")))%></td>
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(cls.get("SETT_DT")))%></td>			
                    <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(cls.get("RENT_TOT_AMT")))%>원&nbsp;</td>
                    <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(cls.get("RENT_SETT_AMT")))%>원&nbsp;</td>
                    <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(cls.get("PAY_AMT")))%>원&nbsp;</td>			
                    <td width='70' align='center'><%=c_db.getNameById(String.valueOf(cls.get("BUS_ID")), "USER")%></td>
                    <td width='70' align='center'><%=c_db.getNameById(String.valueOf(cls.get("MNG_ID")), "USER")%></td>
                </tr>
              <%		}%>
                <tr> 
                    <td colspan="13" class='title'>&nbsp;</td>
                </tr>
            </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
    	<td class='line' width='520' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
        		    <td align='center'>등록된 데이타가 없습니다</td>
        		</tr>
    	    </table>
    	</td>
    	<td class='line' width='1090'>			
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

