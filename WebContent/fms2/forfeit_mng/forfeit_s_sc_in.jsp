<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/acar/car_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=620, height=500, scrollbars=yes");		
	}			
	
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
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"2":request.getParameter("gubun1");  //납입일자
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");//당일, 당월, 기간
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4"); //납입일자
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String coll_yn 	= request.getParameter("coll_yn")==null?"":request.getParameter("coll_yn");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String rent="";
	int total_su = 0;
	long total_amt = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddForfeitDatabase afm_db = AddForfeitDatabase.getInstance();
	
	Vector fines = afm_db.getFineExpPreProxyList1(br_id, gubun1, gubun2, "2", "8", st_dt, end_dt, s_kd, t_wd, coll_yn, "1", asc, coll_yn);
	int fine_size = fines.size();
	
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=fine_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='2000'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='20%' id='td_title' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                
                    <td width='15%' class='title'>연번</td>
                    <td width='20%' class='title'>계약번호</td>
                    <td width='30%' class='title'>상호</td>
                    <td width="20%" class='title'>차량번호</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='80%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=7% class='title'>차명</td>
                    <td width=5% class='title'>과실구분</td>
                    <td width=5% class='title'>납부구분</td>
                    <td width=7% class='title'>청구기관</td>
                    <td width=9% class='title'>위반일시</td>
                    <td width=9% class='title'>위반장소</td>
                    <td width=7% class='title'>위반내용</td>
                    <td width=11% class='title'>고지서번호</td>
                    <td width=6% class='title'>납부금액</td>
                    <td width=5% class='title'>납부기한</td>
                    <td width=5% class='title'>납부일자</td>
                    <td width=5% class='title'>청구일자</td>			
                    <td width=5% class='title'>수금일자</td>			
                    <td width=5% class='title'>업무과실자</td>
                    <td width=4% class='title'>담당자</td>
                    <td width=4% class='title'>스캔파일</td>
                </tr>
            </table>
	    </td>
    </tr>
<%	if(fine_size > 0){%>
    <tr>
	    <td class='line' width='20%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	        
          <%		for (int i = 0 ; i < fine_size ; i++){
			Hashtable fine = (Hashtable)fines.elementAt(i);
			String gubun_chk = (String)fine.get("GUBUN");
		
			%>
                <tr> 
            	
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='15%' align='center'><%=i+1%> 
                      <%if(fine.get("USE_YN").equals("N")){%>
                      (해약) 
                      <%}%>
                    </td>                 
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='20%' align='center'><a href="javascript:parent.view_forfeit('<%=fine.get("RENT_MNG_ID")%>','<%=fine.get("RENT_L_CD")%>','<%=fine.get("CAR_MNG_ID")%>','<%=fine.get("SEQ_NO")%>')" onMouseOver="window.status=''; return true"><%=fine.get("RENT_L_CD")%></a></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='30%' align='center'>
                      <%if(fine.get("FIRM_NM").equals("(주)아마존카") && !fine.get("CUST_NM").equals("$$")){%>
                      <span title='(<%=fine.get("RES_ST")%>)<%=fine.get("CUST_NM")%>'><a href="javascript:parent.view_client('<%=fine.get("RENT_MNG_ID")%>','<%=fine.get("RENT_L_CD")%>', '<%=fine.get("RENT_ST")%>')" onMouseOver="window.status=''; return true">(<%=fine.get("RES_ST")%>)<%=Util.subData(String.valueOf(fine.get("CUST_NM")), 5)%></a></span>	
                      <%}else{%>
                      <span title='<%=fine.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=fine.get("RENT_MNG_ID")%>', '<%=fine.get("RENT_L_CD")%>', '<%=fine.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(fine.get("FIRM_NM")), 9)%></a></span> 
                      <%}%>
        <!--			<span title='<%=fine.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=fine.get("RENT_MNG_ID")%>','<%=fine.get("RENT_L_CD")%>','<%=fine.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(fine.get("FIRM_NM")), 7)%></a></span>-->
        			</td>
                    <td width=20% align='center' <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%>><span title='최초등록번호:<%=fine.get("FIRST_CAR_NO")%>'><%=Util.subData(String.valueOf(fine.get("CAR_NO")), 15)%></span></td>
                </tr>
          <%		}%>
                <tr>                 
                    <td class="title" align='center'>현황</td>		  
                    <td class="title">&nbsp;</td>
                    <td class="title" align='center'>합계</td>			
                    <td class="title">&nbsp;</td>			
                </tr>
            </table>
        </td>
	    <td class='line' width='80%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%		for (int i = 0 ; i < fine_size ; i++){
			Hashtable fine = (Hashtable)fines.elementAt(i);%>
                <tr> 
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=7% align='center'><span title='<%=fine.get("CAR_NM")%>'><%=Util.subData(String.valueOf(fine.get("CAR_NM")), 6)%></span></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=5% align='center'><%=fine.get("FAULT_ST")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=5% align='center'><%=fine.get("PAID_ST")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=7% align='center'><span title='<%=fine.get("GOV_NM")%>'><%=Util.subData(String.valueOf(fine.get("GOV_NM")), 6)%></span></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=9% align='center'><%=fine.get("VIO_DT")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=9% align='center'><span title='<%=fine.get("VIO_PLA")%>'><%=Util.subData(String.valueOf(fine.get("VIO_PLA")), 8)%></span></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=7% align='center'><span title='<%=fine.get("VIO_CONT")%>'><%=Util.subData(String.valueOf(fine.get("VIO_CONT")), 5)%></span></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=11% align='center'><span title='<%=fine.get("PAID_NO")%>'><%=Util.subData(String.valueOf(fine.get("PAID_NO")), 20)%></span></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=6% align='right'><%=Util.parseDecimal(String.valueOf(fine.get("PAID_AMT")))%> 
                      <input type='hidden' name='amt' value='<%=Util.parseDecimal(String.valueOf(fine.get("PAID_AMT")))%>' size='7' class='whitenum' readonly>
                      </td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=5% align='center'><%=fine.get("PAID_END_DT")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=5% align='center'><%=fine.get("PROXY_DT")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=5% align='center'><%=fine.get("DEM_DT")%></td>			
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=5% align='center'><%=fine.get("COLL_DT")%></td>			
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=5% align='center'><%=c_db.getNameById((String)fine.get("FAULT_NM"), "USER")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=4% align='center'><%=c_db.getNameById((String)fine.get("MNG_ID"), "USER")%></td>					
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=4% align='center'> 
                      <%if(!fine.get("SCAN_FILE").equals("")){%>
                      <a href="javascript:view_scan('<%=fine.get("RENT_MNG_ID")%>','<%=fine.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_gys.gif align=absmiddle border=0></a> 
                      <%}%>
                    </td>
                </tr>
          <%			total_su = total_su + 1;	
						total_amt = total_amt  + Long.parseLong(String.valueOf(fine.get("PAID_AMT")));
		}%>
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>			
                    <td class="title">&nbsp;</td>						
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>			
                    <td class="title">&nbsp;</td>			
                    <td class="title">&nbsp;</td>						
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>					
                    <td class="title">&nbsp;</td>			
                    <td class="title">&nbsp;</td>						
                </tr>
            </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td class='line' width='20%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='80%'>			
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
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=fine_size%>';
//-->
</script>
</body>
</html>