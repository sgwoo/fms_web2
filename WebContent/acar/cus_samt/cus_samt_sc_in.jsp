<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_samt.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_bus = request.getParameter("s_bus")==null?"":request.getParameter("s_bus");  //담당자 
	
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String rent="";
	int total_su = 0;
	long total_amt = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CusSamt_Database cs_db = CusSamt_Database.getInstance();
	Vector sers = cs_db.getServiceList(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, s_bus,  sort_gubun, asc);
	int ser_size = sers.size();
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
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">


<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=ser_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1220'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='43%' id='td_title' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='15%' class='title'>연번</td>
                    <td width='20%' class='title'>계약번호</td>
                    <td width='23%' class='title'>상호</td>
                    <td width='18%' class='title'>차량번호</td>
                    <td width='23%' class='title'>차명</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='57%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='9%' class='title'>사고유형</td>
                    <td width='11%' class='title'>정비구분</td>
                    <td width='12%' class='title'>정비일자</td>			
                    <td width='15%' class='title'>정비업체</td>
                    <td width='14%' class='title'>점검내용</td>
                    <td width='10%' class='title'>주행거리</td>
                    <td width='12%' class='title'>정비금액</td>
                    <td width='10%' class='title'>지출일자</td>
                    <td width="8%" class='title'>점검자</td>
                </tr>
            </table>
	    </td>
    </tr>
<%	if(ser_size > 0){%>
    <tr>
	    <td class='line' width='43%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for (int i = 0 ; i < ser_size ; i++){
			Hashtable ser = (Hashtable)sers.elementAt(i);%>
                <tr> 
                    <td <%if(ser.get("USE_YN").equals("N")){%>class='is'<%}%> width='15%' align='center'><a name="<%=i+1%>"><%=i+1%> 
                      <%if(ser.get("USE_YN").equals("N")){%>
                      (해약) 
                      <%}%>
                      </a></td>
                    <td <%if(ser.get("USE_YN").equals("N")){%>class='is'<%}%> width='20%' align='center'><a href="javascript:parent.view_service('<%=ser.get("RENT_MNG_ID")%>','<%=ser.get("RENT_L_CD")%>','<%=ser.get("CAR_MNG_ID")%>','<%=ser.get("ACCID_ID")%>','<%=ser.get("SERV_ID")%>', '<%=i%>')" onMouseOver="window.status=''; return true"><%=ser.get("RENT_L_CD")%></a></td>
                    <td <%if(ser.get("USE_YN").equals("N")){%>class='is'<%}%> width='23%' align='left'>&nbsp;<span title='<%=ser.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=ser.get("RENT_MNG_ID")%>','<%=ser.get("RENT_L_CD")%>','<%=ser.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(ser.get("FIRM_NM")), 8)%></a></span></td>
                    <td <%if(ser.get("USE_YN").equals("N")){%>class='is'<%}%> width='18%' align='center'><%=ser.get("CAR_NO")%></td>
                    <td <%if(ser.get("USE_YN").equals("N")){%>class='is'<%}%> width='23%' align='left' height="40">&nbsp;<span title='<%=ser.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ser.get("CAR_NM")), 8)%></span></td>
                </tr>
          <%
				total_su = total_su + 1;
				total_amt = total_amt + Long.parseLong(String.valueOf(ser.get("TOT_AMT")));
		  		}%>
                <tr> 
                    <td width='15%' class='title'>합계</td>
                    <td width='20%' class='title'>건수</td>
                    <td width='23%' class='title'><%=total_su%>건</td>
                    <td width='18%' class='title'>금액</td>
                    <td width='23%' class='title' style='text-align:right'><%=Util.parseDecimal(total_amt)%>원&nbsp;</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='57%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for (int i = 0 ; i < ser_size ; i++){
    			Hashtable ser = (Hashtable)sers.elementAt(i);%>
                <tr> 
                    <td <%if(ser.get("USE_YN").equals("N")){%>class='is'<%}%> width='9%' align='center'><%=ser.get("ACCID_ST_NM")%></td>
                    <td <%if(ser.get("USE_YN").equals("N")){%>class='is'<%}%> width='11%' align='center'><%=ser.get("SERV_ST")%></td>
                    <td <%if(ser.get("USE_YN").equals("N")){%>class='is'<%}%> width='12%' align='center'><%=ser.get("SERV_DT")%></td>
                    <td <%if(ser.get("USE_YN").equals("N")){%>class='is'<%}%> width='15%' align='left'>&nbsp;<span title='<%=ser.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ser.get("OFF_NM")), 5)%></span></td>
                    <td <%if(ser.get("USE_YN").equals("N")){%>class='is'<%}%> width='14%' align='left'>&nbsp;<span title='<%=ser.get("REP_CONT")%>'><%=Util.subData(String.valueOf(ser.get("REP_CONT")), 5)%></span></td>
                    <td <%if(ser.get("USE_YN").equals("N")){%>class='is'<%}%> width='10%' align='right'><%=Util.parseDecimal(String.valueOf(ser.get("TOT_DIST")))%>km&nbsp;</td>
                    <td <%if(ser.get("USE_YN").equals("N")){%>class='is'<%}%> width='11%' align='right'><%=Util.parseDecimal(String.valueOf(ser.get("TOT_AMT")))%>원&nbsp;</td>
                    <td <%if(ser.get("USE_YN").equals("N")){%>class='is'<%}%> width='10%' align='center'><%=ser.get("SET_DT")%></td>			
                    <td <%if(ser.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width="8%">
        			  <%if(String.valueOf(ser.get("CHECKER")).substring(0,1).equals("0")){%>
        			  <%=c_db.getNameById(String.valueOf(ser.get("CHECKER")), "USER")%>
        			  <%}else{%>
        			  <%=ser.get("CHECKER")%>			  
        			  <%}%>
        			</td>
                </tr>
              <%		}%>
                <tr> 
                    <td colspan="9" class='title'>&nbsp;</td>
                </tr>
            </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td class='line' width='43%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='57%'>			
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
