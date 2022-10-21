<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus0401.*" %>
<jsp:useBean id="cnd" scope="page" class="acar.common.ConditionBean"/>
<jsp:useBean id="c41_scBn" class="acar.cus0401.Cus0401_scBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"21":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_bus = request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String s_brch = request.getParameter("s_brch")==null?"":request.getParameter("s_brch");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");

	cnd.setGubun1(gubun1);
	cnd.setGubun2(gubun2);
	cnd.setGubun3(gubun3);
	cnd.setGubun4(gubun4);
	cnd.setSt_dt(st_dt);
	cnd.setEnd_dt(end_dt);
	cnd.setS_kd(s_kd);
	cnd.setT_wd(t_wd);
	cnd.setS_bus(s_bus);
	cnd.setS_brch(s_brch);
	cnd.setSort_gubun(sort_gubun);
	cnd.setAsc(asc);
	
	Cus0401_Database c41_Db = Cus0401_Database.getInstance();
	Cus0401_scBean[] c41_scBns = c41_Db.getCarList(cnd);
	
	CommonDataBase c_db = CommonDataBase.getInstance();	

%>

<html>
<head>
<title>FMS</title>

<script language="JavaScript">
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
	function init()
	{		
		setupEvents();
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width=1200>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width=40% id='td_title' style='position:relative;'> 
	    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
	       		<tr> 
		            <td width=10% class='title' >연번</td>
		            <td width=20% class='title'>계약번호</td>
		            <td width=26% class='title'>상호</td>
		            <td width=17% class='title' >차량번호</td>
		            <td width=27% class='title'>차명</td>
		       </tr>
			</table>
		</td>
		<td class='line' width=60%>			
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width='8%' class='title'>대여방식</td>
					<td width='11%' class='title'>최근정비일자</td>
			<!--	    <td width='11%' class='title'>정비예정일자</td> -->
					<td width='11%' class='title'>최근주행거리</td>
			<!--		<td width='13%' class='title'>현재예상주행거리</td> -->
	                <td width='10%' class='title'>등록일</td>
	                <td width='10%' class='title'>계약시작일</td>
	                <td width='10%' class='title'>계약만료일</td>
	                <td width='7%' class='title'>영업소</td>
	                <td width='9%' class='title'>관리담당자</td>
				</tr>
			</table>
		</td>
	</tr>
<%if(c41_scBns.length !=0 ){%>
	<tr>		
        <td class='line' width=40% id='td_con' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
             <% for(int i=0; i< c41_scBns.length; i++){
    				c41_scBn = c41_scBns[i];
    				String client_id = c_db.getClinet_id(c41_scBn.getRent_mng_id(),c41_scBn.getRent_l_cd());
    		%>
                <tr> 
                    <td width=10% align='center'><%=i+1%></td>
                    <td width=20% align='center'><%=c41_scBn.getRent_l_cd()%></td>
                    <td width=26% align='left'><span title='<%=c41_scBn.getFirm_nm()%>'>&nbsp;<a href="javascript:parent.view_client('<%=client_id%>','1')" onMouseOver="window.status=''; return true"><%=AddUtil.subData(c41_scBn.getFirm_nm(),8)%></a></span></td>
                    <td width=17% align='center'><a href="javascript:parent.view_detail('<%=c41_scBn.getCar_mng_id()%>','<%=c41_scBn.getRent_mng_id()%>','<%=c41_scBn.getRent_l_cd()%>')"><%=c41_scBn.getCar_no()%></a></td>
                    <td width=27%><span title='<%=c41_scBn.getCar_jnm()+" "+c41_scBn.getCar_nm()%>'>&nbsp;<%=AddUtil.subData(c41_scBn.getCar_jnm()+" "+c41_scBn.getCar_nm(),10)%></span></td>
                </tr>
            <%} %>
            </table>
        </td>
		<td class='line' width=60%>			
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <% for(int i=0; i< c41_scBns.length; i++){
					c41_scBn = c41_scBns[i];			
	%>
                <tr>
                    <td width='8%' align='center' ><%if(c41_scBn.getRent_way().equals("1")){%>일반식<%}else if(c41_scBn.getRent_way().equals("2")){%>기본식<%}else if(c41_scBn.getRent_way().equals("3")){%>기본식<%}%></td>			  
    			  	<td width='11%' align='center' ><%=AddUtil.ChangeDate2(c41_scBn.getServ_dt())%></td>
      		<!--	    <td width='11%' align='center'><%=AddUtil.ChangeDate2(c41_scBn.getNext_serv_dt())%></td> -->
    				<td width='11%' align='right'><%=AddUtil.parseDecimal(c41_scBn.getTot_dist())%>&nbsp;km&nbsp;</td>
    		<!--		<td width='13%' align='right'><a href="#" ><%=AddUtil.parseDecimal(c41_scBn.getToday_dist())%>&nbsp;km</a>&nbsp;&nbsp;</td>	-->			
                    <td width='10%' align='center' ><span title='<%=c41_scBn.getFirm_nm()%>'><%=AddUtil.ChangeDate2(c41_scBn.getInit_reg_dt())%> </span></td>
                    <td width='10%' align='center' ><%=AddUtil.ChangeDate2(c41_scBn.getRent_start_dt())%></td>
                    <td width='10%' align='center' ><%=AddUtil.ChangeDate2(c41_scBn.getRent_end_dt())%></td>
                    <td width='7%' align='center' ><%=c41_scBn.getBrch_id()%></td>
                    <td width='9%' align='center' ><%=c_db.getNameById(c41_scBn.getMng_id(), "USER")%></td>
                </tr>
              <%}%>
            </table>
		</td>
	</tr>	
<%	}else{%>
	<tr>		
        <td class='line' width=40% id='td_con' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
            </table>
        </td>
		<td class='line' width=60%>			
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	} %>
</table>
</body>
</html>
