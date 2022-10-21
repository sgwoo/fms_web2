<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.offls_yb.*, acar.common.*, acar.estimate_mng.*"%>
<jsp:useBean id="olyBean" class="acar.offls_yb.Offls_ybBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="srBn" class="acar.secondhand.ShResBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<rows>	

<%
	String auth_rw 			= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 			= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 				= request.getParameter("br_id")		==null?"":request.getParameter("br_id");		
	
	String gubun 			= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun_nm 		= request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String brch_id 			= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String gubun2 			= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String res_yn 			= request.getParameter("res_yn")	==null?"":request.getParameter("res_yn");
	String res_mon_yn	= request.getParameter("res_mon_yn")	==null?"":request.getParameter("res_mon_yn");
	String all_car_yn		= request.getParameter("all_car_yn")	==null?"":request.getParameter("all_car_yn");
	String agent_yn		= request.getParameter("agent_yn")	==null?"Y":request.getParameter("agent_yn");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	if(!gubun_nm.equals("")) gubun_nm = AddUtil.replace(gubun_nm,"'","");
	
	//에이전트는 대기 && 예약가능 건들만 디폴트로 검색되게(20190924)
	Vector vts = shDb.getSecondhandList_20120821(gubun2, gubun, gubun_nm, brch_id, sort_gubun, res_yn, res_mon_yn, all_car_yn, agent_yn);
	int vt_size = vts.size();
	
	
	if(vt_size > 0 ) {
		for(int i = 0 ; i < vt_size ; i++) {
			Hashtable ht = (Hashtable)vts.elementAt(i);
			%>
			
			<row  id='<%=i+1%>'>
			<cell><![CDATA[<%=i+1%>]]></cell>
			<cell>
				<% if(!String.valueOf(ht.get("ACTN_ST")).equals("")){ 
						//경매정보
						Hashtable ht_apprsl 	= shDb.getCarApprsl(String.valueOf(ht.get("CAR_MNG_ID")));%>
					<![CDATA[<font color=green>	
					<% if(String.valueOf(ht.get("ACTN_ST")).equals("유찰")){ %>
	                           	<span title='[<%=ht.get("ACTN_ST")%>] 경매장:<%=ht_apprsl.get("FIRM_NM")%>, 평가일자:<%=AddUtil.ChangeDate2(String.valueOf(ht_apprsl.get("APPRSL_DT")))%>, 경매일자:<%=ht.get("ACTN_DT")%>, 다음경매예정일:<%=ht.get("ACTN_EST_DT")%>'>경매:<%=ht.get("ACTN_EST_DT")%> </span> 												
					<% }else{%>
	                           	<span title='[<%=ht.get("ACTN_ST")%>] 경매장:<%=ht_apprsl.get("FIRM_NM")%>, 평가일자:<%=AddUtil.ChangeDate2(String.valueOf(ht_apprsl.get("APPRSL_DT")))%>, 경매일자:<%=ht.get("ACTN_DT")%> <%if(String.valueOf(ht.get("RENT_ST")).equals("네고중")){ %> ( <%=ht.get("SITU_NM")%>)  <%} %> '><%=ht.get("RENT_ST")%></span> 												
					<% }%>
					</font>]]>
				<%}else{%>	
					<% 	if(String.valueOf(ht.get("RENT_ST")).equals("대기")){ %>
						<![CDATA[<%=ht.get("RENT_ST")%><font color='#999999'><span title='<%=ht.get("PARK_CONT")%>'>(<%=AddUtil.subData(String.valueOf(ht.get("PARK")),4)%>)</span></font>]]>
					<% 	}else if(String.valueOf(ht.get("RENT_ST")).equals("매각결정")){ %>
						<![CDATA[<font color="red"><%=ht.get("RENT_ST")%></font>]]>
					<%	}else{%>
						<![CDATA[<span title='[<%=ht.get("RENT_ST")%>] 반차예정일:<%=ht.get("RET_PLAN_DT")%>'><%if(String.valueOf(ht.get("RENT_ST")).equals("월렌트")){%><font color="red"><%=ht.get("RENT_ST")%></font><%}else{%><%=ht.get("RENT_ST")%><%}%><font color='#999999'><%=AddUtil.ChangeDate(String.valueOf(ht.get("RET_PLAN_DT")),"MM/DD")%></font></span>]]> 
					<%	}%>								
	            <% } %>
			</cell>
			<cell><![CDATA[<%=ht.get("SITUATION")%>]]></cell>
			<cell><![CDATA[<font color="#FF66FF"><span title='<%=ht.get("MEMO")%> 예약기간:<%=ht.get("RES_ST_DT")%>~<%=ht.get("RES_END_DT")%>'><%=ht.get("SITU_NM")%><%=AddUtil.ChangeDate(String.valueOf(ht.get("RES_END_DT")),"MM/DD")%></span></font>]]></cell>
			<%if(String.valueOf(ht.get("RES_CNT")).equals("1")||String.valueOf(ht.get("RES_CNT")).equals("2")){ 
					Vector sr = shDb.getShResList(String.valueOf(ht.get("CAR_MNG_ID")));
					int sr_size = sr.size();
					if(sr_size >3) sr_size=3;
					for(int j = 1 ; j < sr_size ; j++){
						Hashtable sr_ht = (Hashtable)sr.elementAt(j);%>
                    	<cell><![CDATA[<%=c_db.getNameById(String.valueOf(sr_ht.get("DAMDANG_ID")),"USER")%>]]></cell>	
			<%	}%>
			<%	if(sr_size==2){%>
                    	<cell><![CDATA[&nbsp;]]>	</cell>
			<%	}%>
			<%	if(sr_size==1){%>
                    	<cell><![CDATA[&nbsp;]]></cell>		
                        <cell><![CDATA[&nbsp;]]>	</cell>									
			<%	}%>
			<%}else{%>
                  	<cell><![CDATA[&nbsp;]]></cell>
                 	<cell><![CDATA[&nbsp;]]>	</cell>									
			<%}%>
			<cell><![CDATA[<span title='<%=ht.get("RM_CONT")%>'><%if(String.valueOf(ht.get("RM_ST")).equals("즉시")){%><font color=red><%}%><%=ht.get("RM_ST")%><%if(String.valueOf(ht.get("RM_ST")).equals("즉시")){%></font><%}%></span>]]></cell>
			<cell><![CDATA[<a href="javascript:view_detail('<%=auth_rw%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("JG_CODE")%>')"><%=ht.get("CAR_NO")%></a>]]></cell>
			<%-- <cell><![CDATA[<span title='<%=ht.get("CAR_NM")%> <%=ht.get("CAR_NAME")%>'>&nbsp;<%=AddUtil.substringbdot(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),20)%></span>]]></cell> --%>
			<cell><![CDATA[<span title='<%=ht.get("CAR_NM")%> <%=ht.get("CAR_NAME")%>'>&nbsp;<%=String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME"))%></span>]]></cell>
			
			<cell>
				<%if(!String.valueOf(ht.get("PIC_CNT")).equals("0")){%>				  
				    <![CDATA[<a href="javascript:MM_openBrWindow('/acar/secondhand_hp/bigimg.jsp?c_id=<%=ht.get("CAR_MNG_ID")%>&pic_cnt=<%=ht.get("PIC_CNT")%>','popwin0','scrollbars=no,status=no,resizable=yes,width=800,height=600,left=50, top=50')" title="차량사진 크게 보기"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>]]>
				<%}%>
			</cell>
			<cell>
			<%if(!String.valueOf(ht.get("PIC_CNT")).equals("0")){%>
				<![CDATA[<%=ht.get("PIC_REG_DT")%>]]>
			<%}%>
			</cell>
			<cell><![CDATA[<span title='<%=ht.get("FUEL_KD")%>'><%=AddUtil.subData(String.valueOf(ht.get("FUEL_KD")),4)%></span>]]></cell>
			<cell><![CDATA[<span title='<%=ht.get("COLO")%>'><%=String.valueOf(ht.get("COLO"))%></span>]]></cell>
			<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%>]]></cell>
			<cell><![CDATA[<%=ht.get("USE_MON")%>]]></cell>
			<cell><![CDATA[<%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_DIST")))%>]]></cell>
			<cell><![CDATA[<%=ht.get("PARK_NM")%><%=ht.get("AREA")%>]]></cell>
			<cell><![CDATA[<%=ht.get("ACCID_YN")%>]]></cell>
			<cell><![CDATA[<span title='<%=ht.get("OPT")%>'> <%=AddUtil.subData(String.valueOf(ht.get("OPT")), 10)%></span>]]></cell>
		</row>
<%}

}%>
		
	

</rows>	
