<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.car_accident.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
	}
	
	//수정: 스캔 보기
	function view_map(map_path){
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("http://211.238.135.5/data/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}	
	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/acar/car_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=620, height=500, scrollbars=yes");		
	}		
	//업체별 과태료 청구문서
	function view_fine_doc(client_id, bus_id2){
		window.open("/acar/account/fine_reqdoc_select.jsp?client_id="+client_id+"&bus_id2="+bus_id2, "VIEW_FINE_DOC", "left=100, top=100, width=950, height=600, scrollbars=yes");	
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
	String gubun1 = request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
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
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarAccidDatabase a_cad = AddCarAccidDatabase.getInstance();
	
	AddForfeitDatabase afm_db = AddForfeitDatabase.getInstance();
	Vector fines = afm_db.getFineList(br_id, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int fine_size = fines.size();
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=fine_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='2005'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='525' id='td_title' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                    <td width='70' class='title'>연번</td>
                    <td width='60' class='title'>구분</td>
                    <td width='105' class='title'>계약번호</td>
                    <td width='160' class='title'>상호</td>
                    <td width='100' class='title'>차량번호</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='1480'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='100' class='title'>차명</td>
                    <td width='70' class='title'>과실구분</td>
                    <td width='80' class='title'>업무과실자</td>			
                    <td width='70' class='title'>납부구분</td>			
                    <td width='90' class='title'>위반일자</td>
                    <td width='100' class='title'>위반장소</td>
                    <td width='100' class='title'>위반내용</td>			
                    <td width='80' class='title'>납부금액</td>
                    <td width='90' class='title'>납부기한</td>
                    <td width='90' class='title'>대납일자</td>
                    <td width='90' class='title'>청구일자</td>						
                    <td width='90' class='title'>입금예정일</td>
                    <td width='90' class='title'>수금일자</td>
                    <td width='60' class='title'>연체일수</td>
                    <td width='60' class='title'>영업담당</td>
                    <td width='60' class='title'>담당자</td>					
                    <td width='80' class='title'>스캔파일</td>			
                    <td width='80' class='title'>등록자</td>					
                </tr>
            </table>
	    </td>
    </tr>
<%	if(fine_size > 0){%>
    <tr>
	    <td class='line' width='525' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%		for (int i = 0 ; i < fine_size ; i++){
			Hashtable fine = (Hashtable)fines.elementAt(i);%>
                <tr> 
            	    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='30' align='center'><input type="checkbox" name="ch_l_cd" value="<%=fine.get("RENT_MNG_ID")%><%=fine.get("RENT_L_CD")%><%=fine.get("CAR_MNG_ID")%><%=fine.get("SEQ_NO")%>"></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='70' align='center'><a name="<%=i+1%>"><%=i+1%></a><%if(fine.get("USE_YN").equals("N")){%>(해약)<%}%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='center'><a href="javascript:parent.view_memo('<%=fine.get("RENT_MNG_ID")%>','<%=fine.get("RENT_L_CD")%>','<%=fine.get("CAR_MNG_ID")%>','5','','','<%=fine.get("MNG_ID")%>')" onMouseOver="window.status=''; return true"  title="<%=a_cad.getMaxMemo(String.valueOf(fine.get("RENT_MNG_ID")), String.valueOf(fine.get("RENT_L_CD")), "5", "", "")%>"><%=fine.get("GUBUN")%></a></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='105' align='center'><a href="javascript:parent.view_forfeit('<%=fine.get("RENT_MNG_ID")%>','<%=fine.get("RENT_L_CD")%>','<%=fine.get("CAR_MNG_ID")%>', '<%=fine.get("SEQ_NO")%>')" onMouseOver="window.status=''; return true"><%=fine.get("RENT_L_CD")%></a></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='160' align='center'>
                      <%if(fine.get("FIRM_NM").equals("(주)아마존카") && !fine.get("CUST_NM").equals("")){%>
                      <span title='(<%=fine.get("RES_ST")%>)<%=fine.get("CUST_NM")%>'><a href="javascript:parent.view_client('<%=fine.get("RENT_MNG_ID")%>','<%=fine.get("RENT_L_CD")%>', '<%=fine.get("RENT_ST")%>')" onMouseOver="window.status=''; return true">(<%=fine.get("RES_ST")%>)<%=Util.subData(String.valueOf(fine.get("CUST_NM")), 6)%></a></span>	
                      <%}else{%>
                      <span title='<%=fine.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=fine.get("RENT_MNG_ID")%>', '<%=fine.get("RENT_L_CD")%>', '<%=fine.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(fine.get("FIRM_NM")), 11)%></a></span> 
                      <%}%>                
        	    </td>
                    <td width="100" align='center' <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%>><span title='최초등록번호:<%=fine.get("FIRST_CAR_NO")%>'><%=fine.get("CAR_NO")%></span></td>
                </tr>
          <%
		  		}%>
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title" align='center'></td>		  
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">합계</td>			
                    <td class="title">&nbsp;</td>			
                </tr>
            </table>
        </td>
	    <td class='line' width='1480'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%		for (int i = 0 ; i < fine_size ; i++){
			Hashtable fine = (Hashtable)fines.elementAt(i);%>
                <tr> 
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='100' align='center'><span title='<%=fine.get("CAR_NM")%> <%=fine.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(fine.get("CAR_NM"))+" "+String.valueOf(fine.get("CAR_NAME")), 6)%></span></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='70' align='center'><%=Util.subData(String.valueOf(fine.get("FAULT_ST")), 4)%></td>
        	    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='center'><%=c_db.getNameById(String.valueOf(fine.get("FAULT_NM")),"USER")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='70' align='center'><%=fine.get("PAID_ST")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='90' align='center'><%=fine.get("VIO_DT")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='100' align='center'><span title='<%=fine.get("VIO_PLA")%>'><%=Util.subData(String.valueOf(fine.get("VIO_PLA")), 6)%></span></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='100' align='center'><span title='<%=fine.get("VIO_CONT")%>'><%=Util.subData(String.valueOf(fine.get("VIO_CONT")), 6)%></span></td>			
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(fine.get("PAID_AMT")))%>원<!--<input type='hidden' name='amt' value='<%=Util.parseDecimal(String.valueOf(fine.get("PAID_AMT")))%>' size='10' class='whitenum' readonly>--></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='90' align='center'><%=fine.get("PAID_END_DT")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='90' align='center'><%=fine.get("PROXY_DT")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='90' align='center'><a href="javascript:view_fine_doc('<%=fine.get("CLIENT_ID")%>', '<%=fine.get("BUS_ID2")%>')"><%=fine.get("DEM_DT")%></a></td>						
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='90' align='center'><%=fine.get("REC_PLAN_DT")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='90' align='center'><%=fine.get("COLL_DT")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='right'><%=Util.parseDecimal(String.valueOf(fine.get("DLY_DAYS")))%>일</td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='center'><%=c_db.getNameById((String)fine.get("BUS_ID2"), "USER")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='center'><%=c_db.getNameById((String)fine.get("FINE_MNG_ID"), "USER")%></td>					
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='center'><%if(!fine.get("SCAN_FILE").equals("")){%><a href="javascript:view_scan('<%=fine.get("RENT_MNG_ID")%>','<%=fine.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_gys.gif align=absmiddle border=0></a><%}%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='center'><%=Util.subData(c_db.getNameById((String)fine.get("REG_ID"), "USER"), 6)%></td>
                </tr>
          <%	total_su = total_su + 1;
				total_amt = total_amt + Long.parseLong(String.valueOf(fine.get("PAID_AMT")));
		  }%>
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>			
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>			
                    <td class="title">&nbsp;</td>						
                    <td class="title">&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>원</td>			
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>			
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
	    <td class='line' width='525' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='1480'>			
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
