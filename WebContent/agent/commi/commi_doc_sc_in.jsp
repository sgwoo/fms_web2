<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = d_db.getCommiDocList(s_kd, t_wd, gubun1, ck_acar_id);
	int vt_size = vt.size();
	
%>

<html>
<head><title>FMS</title>
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
	
	//스캔관리 보기
	function view_scan(m_id, l_cd)
	{
		window.open("/fms2/commi/view_scan_commi.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=720, height=500, scrollbars=yes, status=yes");								
	}		
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
    <table border="0" cellspacing="0" cellpadding="0" width=<%if(!gubun1.equals("2")){%>'1580'<%}else{%>'1335'<%}%>>
        <tr>
            <td class=line2 colspan="2"></td>
        </tr>
        <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='510' id='td_title' style='position:relative;'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		    <tr>
		        <td width='30' class='title' style='height:51'>연번</td>
			<td width='30' class='title'>구분</td>
		        <td width='140' class='title'>계약번호</td>
        		<td width='75' class='title'>계약일</td>
		        <td width="110" class='title'>고객</td>
		        <td width="75" class='title'>차량번호</td>
		        <td width="50" class='title'>최초<br>영업</td>					
		    </tr>
		</table>
	    </td>
	    <td class='line' width=<%if(!gubun1.equals("2")){%>'1070'<%}else{%>'825'<%}%>>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		    <tr>
			<td colspan="5" class='title'>결재</td>									
			<%if(!gubun1.equals("2")){%>											
			<td colspan="6" class='title'>지급조건</td>
			<%}else{ %>
			<td rowspan="2" width='80' class='title'>대여개시일</td>
			<%} %>
			<td colspan="8" class='title'>영업사원</td>
		    </tr>
		    <tr>
			<td width='80' class='title'>기안일자</td>
			<td width='55' class='title'>기안자</td>
			<td width='55' style="font-size:7pt" class='title'>회계관리</td>
			<td width='55' style="font-size:7pt" class='title'>채권관리</td>
			<td width='55' class='title'>팀장</td>
			<%if(!gubun1.equals("2")){%>			
			<td width='30' class='title'>불충</td>				  		  				  
			<td width='30' class='title'>스캔</td>
			<td width='80' class='title'>대여개시일</td>
			<td width='60' style="font-size:7pt" class='title'>보증보험</td>
			<td width='60' style="font-size:7pt" class='title'>초기선납금</td>			
			<td width="65" class='title'>스케줄</td>	
			<%}%>		
			<td width='65' class='title'>영업사원</td>			
			<td width='65' class='title'>신분증외</td>			
			<td width='65' class='title'>영업수당</td>
			<td width='70' class='title'>출고보전</td>
			<td width='60' class='title'>이관권장</td>
			<td width='60' class='title'>진행수당</td>
			<td width='60' class='title'>대리수당</td>
		    </tr>
		</table>
	    </td>
        </tr>
<%
	if(vt_size > 0)
	{
%>
        <tr>
	    <td class='line' width='510' id='td_con' style='position:relative;'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			if(String.valueOf(ht.get("RENT_L_CD")).equals("S113HNER00084") || String.valueOf(ht.get("RENT_L_CD")).equals("S113HNER00085") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("S615KSPR00071") || String.valueOf(ht.get("RENT_L_CD")).equals("S113B52R00047") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("G116KYPR00006") || String.valueOf(ht.get("RENT_L_CD")).equals("S115KF3L00045") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("S515KK9R00008") || String.valueOf(ht.get("RENT_L_CD")).equals("S215HDHR00207") ||
               String.valueOf(ht.get("RENT_L_CD")).equals("D113HHLR00045") || String.valueOf(ht.get("RENT_L_CD")).equals("D114UA4R00005") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("S114HHLR00389") || String.valueOf(ht.get("RENT_L_CD")).equals("S114HLFR00559") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("S114KK5R00216") || String.valueOf(ht.get("RENT_L_CD")).equals("S120HCNR00152") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("S120HRGR00495") || String.valueOf(ht.get("RENT_L_CD")).equals("S121HLXR00040") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("S121KDLR00106") || String.valueOf(ht.get("RENT_L_CD")).equals("S121HNGR00051") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("S121HGVR00031") || String.valueOf(ht.get("RENT_L_CD")).equals("S121KKAR00085") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("S112KK5R00597") || String.valueOf(ht.get("RENT_L_CD")).equals("S119HM4L00087")
			   ) continue;
			
			count++;
			
			//장기전자계약서
			Hashtable alink_lc_rent = new Hashtable();
			int vt_alink_size = 0;
			if(gubun1.equals("1")){
				alink_lc_rent  = ln_db.getAlinkEndLcRent(String.valueOf(ht.get("RENT_L_CD")), "1");				
				if(String.valueOf(alink_lc_rent.get("RENT_L_CD")).equals(String.valueOf(ht.get("RENT_L_CD")))){
					vt_alink_size = 1;
				}
			}	
%>
		    <tr>
			<td  width='30' align='center'><%=count%></td>
			<td  width='30' align='center'><%=ht.get("BIT")%></td>
			<td  width='140' align='center' <%if(vt_alink_size >0){%>style="color: red;"<%}%>><%if(vt_alink_size >0){%>(전자) <%}%><%=ht.get("RENT_L_CD")%></td>
			<td  width='75' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
			<td  width='110'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.substringbdot(String.valueOf(ht.get("FIRM_NM")), 14)%></a></span></td>
			<td  width='75' align='center'><%=ht.get("CAR_NO")%></td>			
			<td  width='50' align='center'><%=c_db.getNameById(String.valueOf(ht.get("BUS_ID")),"USER")%></td>					
		    </tr>
<%
		}
%>
		</table>
	    </td>
	    <td class='line' width=<%if(!gubun1.equals("2")){%>'1070'<%}else{%>'825'<%}%>>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			if(String.valueOf(ht.get("RENT_L_CD")).equals("S113HNER00084") || String.valueOf(ht.get("RENT_L_CD")).equals("S113HNER00085") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("S615KSPR00071") || String.valueOf(ht.get("RENT_L_CD")).equals("S113B52R00047") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("G116KYPR00006") || String.valueOf(ht.get("RENT_L_CD")).equals("S115KF3L00045") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("S515KK9R00008") || String.valueOf(ht.get("RENT_L_CD")).equals("S215HDHR00207") ||
               String.valueOf(ht.get("RENT_L_CD")).equals("D113HHLR00045") || String.valueOf(ht.get("RENT_L_CD")).equals("D114UA4R00005") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("S114HHLR00389") || String.valueOf(ht.get("RENT_L_CD")).equals("S114HLFR00559") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("S114KK5R00216") || String.valueOf(ht.get("RENT_L_CD")).equals("S120HCNR00152") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("S120HRGR00495") || String.valueOf(ht.get("RENT_L_CD")).equals("S121HLXR00040") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("S121KDLR00106") || String.valueOf(ht.get("RENT_L_CD")).equals("S121HNGR00051") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("S121HGVR00031") || String.valueOf(ht.get("RENT_L_CD")).equals("S121KKAR00085") ||
			   String.valueOf(ht.get("RENT_L_CD")).equals("S112KK5R00597") || String.valueOf(ht.get("RENT_L_CD")).equals("S119HM4L00087")
			   ) continue;
			   			   						
						
			String scan_cnt			= String.valueOf(ht.get("SCAN_CNT"));
			String rent_start_dt 	= String.valueOf(ht.get("RENT_START_DT"));
			String gi_st 			= String.valueOf(ht.get("GI_ST2"));
			String pp_st 			= String.valueOf(ht.get("PP_ST"));
			String scd_yn 			= String.valueOf(ht.get("SCD_YN"));
			String req_dt			= String.valueOf(ht.get("REQ_DT"));
			String sup_dt			= String.valueOf(ht.get("SUP_DT"));
			
			int chk_cnt = 0;
			
			if(!gubun1.equals("2")){
				if(scan_cnt.equals("0"))						chk_cnt++;
				if(rent_start_dt.equals("")) 					chk_cnt++;
				if(gi_st.equals("미가입"))						chk_cnt++;
				if(pp_st.equals("미입금")||pp_st.equals("잔액"))	chk_cnt++;
			}	
			
%>			
		    <tr>
		        <!--기안자-->
		    <td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("T_USER_DT1")))%></td>    
			<td  width='55' align='center'>			    
			    <%	if(String.valueOf(ht.get("USER_DT1")).equals("")){%>
			    <%		if(!user_id.equals(String.valueOf(ht.get("아마존카이외")))){%>
						<a href="javascript:parent.commi_action(<%=chk_cnt%>, '1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gian.gif"  border="0" align=absmiddle></a>
			    <%		}else{%>-<%}%>
			    <%	}else{%>
			    			<a href="javascript:parent.commi_action(<%=chk_cnt%>, '1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID1")),"USER")%></a>
			    <%	}%>
			</td>			 
			<!--회계관리자-->
			<td  width='55' align='center'>
			    <%	if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT6")).equals("")){%>
			    <%		if(String.valueOf(ht.get("USER_ID6")).equals(user_id)){%>
			 		  	<a href="javascript:parent.commi_action(<%=chk_cnt%>, '6', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif"  border="0" align=absmiddle></a>
			    <%		}else{%>-<%}%>
			    <%	}else{%>	<a href="javascript:parent.commi_action(<%=chk_cnt%>, '6', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID6")),"USER")%></a>
			    <%	}%>
			</td>
			<!--채권관리자-->
			<td  width='55' align='center'>
			    <%	if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT7")).equals("")){%>
			    <%		if(String.valueOf(ht.get("USER_ID7")).equals(user_id)){%>
					  	<a href="javascript:parent.commi_action(<%=chk_cnt%>, '7', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif"  border="0" align=absmiddle></a>
			    <%		}else{%>-<%}%>
			    <%	}else{%>	<a href="javascript:parent.commi_action(<%=chk_cnt%>, '7', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID7")),"USER")%></a>
			    <%	}%>
			</td>
			<!--총무팀장-->  
			<td  width='55' align='center'>
			    <%	if(!String.valueOf(ht.get("USER_ID8")).equals("XXXXXX")){%> 	
			    <%		if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT8")).equals("")){%>
			    <%			if(String.valueOf(ht.get("USER_ID8")).equals(user_id)){%>
			  	  		<a href="javascript:parent.commi_action(<%=chk_cnt%>, '8', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif"  border="0" align=absmiddle></a>
			    <%			}else{%>-<%}%>
			    <%		}else{%><a href="javascript:parent.commi_action(<%=chk_cnt%>, '8', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID8")),"USER")%></a>
			    <%		}%>
			    <%	}else{%>-<%}%>
			</td>
			<%if(!gubun1.equals("2")){%>	
			<td  width='30' align='center'><%=chk_cnt%></td>										
			<td  width='30' align='center'><%=scan_cnt%></td>
			<td  width='80' align='center'><%=AddUtil.ChangeDate2(rent_start_dt)%><%if(rent_start_dt.equals("")){%><font color=red>미개시</font><%}%></td>					
			<td  width='60' align='center'><%if(gi_st.equals("미가입")){%><font color=red><%}%><%=gi_st%><%if(gi_st.equals("미가입")){%></font><%}%></td>
			<td  width='60' align='center'><%if(pp_st.equals("미입금")||pp_st.equals("잔액")){%><font color=red><%}%><span title='<%=Util.parseDecimal(String.valueOf(ht.get("JAN_AMT")))%>원'><%=pp_st%></span><%if(pp_st.equals("미입금")||pp_st.equals("잔액")){%></font><%}%></td>							
			<td  width='65' align='center'><%=scd_yn%></td>		
			<%}else{%>						
			<td  width='80' align='center'><%=AddUtil.ChangeDate2(rent_start_dt)%></td>
			<%}%>
			<td  width='65' align='center'><span title='<%=ht.get("EMP_NM")%>'><a href="javascript:parent.view_emp('<%=ht.get("EMP_ID")%>')";><%=AddUtil.subData(String.valueOf(ht.get("EMP_NM")), 4)%></a></span></td>
			<td  width='65' align='center'><a href="javascript:view_scan('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='스캔관리'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>			
			<td  width='65' align='center'><%=ht.get("COMM_R_RT")%>%</td>
			<td  width='70' align='right' style="font-size:8pt"><%=AddUtil.parseDecimal(String.valueOf(ht.get("DLV_CON_COMMI")))%></td>
			<td  width='60' align='right' style="font-size:8pt"><%=AddUtil.parseDecimal(String.valueOf(ht.get("DLV_TNS_COMMI")))%></td>
			<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGENT_COMMI")))%></td>
			<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("PROXY_COMMI")))%></td>
		    </tr>
<%
		}
%>
		</table>
	    </td>
<%	}                  
	else               
	{
%>                     
	<tr>
	    <td class='line' width='510' id='td_con' style='position:relative;'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		    <tr>
			<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width=<%if(!gubun1.equals("2")){%>'1070'<%}else{%>'825'<%}%>>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

