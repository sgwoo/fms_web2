<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_off_id	= request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String s_kd 		= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt 		= request.getParameter("dt")==null?"0":request.getParameter("dt");
	String t_st_dt 		= request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");
	String t_end_dt 	= request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	if(car_off_id.equals("") && nm_db.getWorkAuthUser("외부_자동차사",ck_acar_id)){
		UsersBean user_bean 	= umd.getUsersBean(ck_acar_id);
		car_off_id	= user_bean.getSa_code();		
	}	
		
	Vector stats = a_db.getDlvStats(s_kd, t_wd, dt, t_st_dt, t_end_dt, car_off_id);	
	int stat_size = stats.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='../../include/table_t.css'>
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
	
-->
</script>
</head>
<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding='0' width='1300'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td id='td_title' class=line style='position:relative;' width='410'>
			<table border=0 cellspacing=1 cellpadding=0 width='100%'>
				<tr>
					<td class='title' width='30'>연번</td>
					<td class='title' width='100'>계출번호</td>
					<td class='title' width='80'>계약일</td>	
					<td class='title' width='200'>차명</td>				
            	</tr>
            </table>
		</td>
		<td class='line' width='890'>
			<table border=0 cellspacing=1 cellpadding=0 width='100%'>
		<tr>
            		<td class='title' width='80'>차량번호</td>
            		<td class='title' width='150'>차대번호</td>
            		<td class='title' width='80'>출고일</td>
            		<td class='title' width='80'>등록일</td>
			          <td class='title' width='100'>제조사</td>
            		<td class='title' width='100'>출고지점</td>
            		<td class='title' width='100'>구입가격</td>
            		<td class='title' width='100'>계약자</td>
            		<td class='title' width='100'>사업자번호</td>
		</tr>
			</table>
		</td>
	</tr>
<%
	if(stat_size > 0)
	{
%>
	<tr>
		<td id='td_con' class=line style='position:relative;' width='410'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
<%
		for(int i = 0 ; i < stat_size ; i++)
		{
			Hashtable stat = (Hashtable)stats.elementAt(i);
%>            	
           		<tr>
           			<td align='center' width='30'><%=i+1%></td>
           			<td align='CENTER' width='100'><%=stat.get("RPT_NO")%></td>
           			<td align='CENTER' width='80'><%=stat.get("RENT_DT")%></td>
           			<td align='center' width='200'>&nbsp;<span title='<%=stat.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(stat.get("CAR_NAME")), 16)%></span></td>
           			
            		</tr>
<%		}
%>
           		<tr>
           			<td class="title" colspan='4'>합계</td>             		            		
            		</tr>
			</table>
		</td>
		<td class=line width='890'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
<%
		for(int i = 0 ; i < stat_size ; i++)
		{
			Hashtable stat = (Hashtable)stats.elementAt(i);
			
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(stat.get("CAR_F_AMT")));			
				
%>            				
				<tr>					
                    <td align='center' width='80'><%=stat.get("CAR_NO")%>
                        <%if(!String.valueOf(stat.get("ATTACH_FILE_SEQ")).equals("")){%>
                        <a href="javascript:openPopP('<%=stat.get("ATTACH_FILE_TYPE")%>','<%=stat.get("ATTACH_FILE_SEQ")%>');" title='보기' ><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="등록증보기"></a>                        
                        <%}%>
                    </td>
                    <td align='center' width='150'><%=stat.get("CAR_NUM")%></td>		              		
                    <td align='center' width='80'><%=stat.get("DLV_DT")%></td>            		                    
                    <td align='center' width='80'><%=stat.get("INIT_REG_DT")%></td>            		                    
		    <td align='center' width='100'><%=stat.get("NM2")%></td>	
		    <td align='center' width='100'><span title='<%=stat.get("DLV_OFF")%>'><%=Util.subData(String.valueOf(stat.get("DLV_OFF")), 6)%></span></td>				                    
            	    <td align='right' width='100'><%=Util.parseDecimal(String.valueOf(stat.get("CAR_F_AMT")))%></td>					            	    
            	    <td align='center' width='100'><span title='<%=stat.get("PUR_COM_FIRM")%>'><%=AddUtil.subData(String.valueOf(stat.get("PUR_COM_FIRM")), 7)%></span></td>	
            	    <td align='center' width='100'><%=AddUtil.ChangeEnt_no(String.valueOf(stat.get("PUR_COM_ENP_NO")))%><%if(String.valueOf(stat.get("PUR_COM_ENP_NO")).equals("") && !String.valueOf(stat.get("PUR_COM_FIRM")).equals("")){%><%=AddUtil.ChangeEnt_no(c_db.getNameById(String.valueOf(stat.get("PUR_COM_FIRM")),"ENP_NO"))%><%}%></td>	
           	  </tr>
<%
		}
%>
           		<tr>
           			<td class="title" colspan='6'>&nbsp;</td>           			
            		        <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>    		            		            		        
            		        <td class="title" colspan='2'>&nbsp;</td>           			
            		</tr>

			</table>
		</td>
	</tr>
<%
	}
	else
	{
%>
	<tr>
		<td id='td_con' class=line style='position:relative;' width='410'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td width='810' class='line'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
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
</body>
</html>