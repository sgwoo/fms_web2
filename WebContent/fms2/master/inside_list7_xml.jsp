<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<rows>	

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");	
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	Vector jarr = ad_db.getInsideReq07(start_dt, end_dt);
	
	int jarr_size = 0;
	
	jarr_size = jarr.size();

		
	if(jarr_size > 0) {
		
	
		
		for(int i = 0 ; i < jarr_size ; i++) {
			
			Hashtable ht = (Hashtable)jarr.elementAt(i);
					
			
			
			%>
			
			<row  id='<%=i+1%>'>
				<cell><![CDATA[<%=i+1%>]]></cell>
				<cell><![CDATA[<%=ht.get("RENT_L_CD")%>]]></cell>
				<cell><![CDATA[<%=ht.get("FIRM_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NM")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(String.valueOf(ht.get("O_1")))%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NO")%>]]></cell>				
				<cell><![CDATA[<%=ht.get("BUS_ST")%>]]></cell>
				<cell><![CDATA[<%=ht.get("BUS_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("BUS_NM2")%>]]></cell>   
				<cell><![CDATA[<%=ht.get("CAR_ST")%>]]></cell>
				<cell><![CDATA[<%=ht.get("RENT_WAY")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CON_MON")%>]]></cell>				
				<%
			  		String eval_gr1 = "";
			  		if(eval_gr1.equals("") && String.valueOf(ht.get("EVAL_OFF1")).equals("크레탑")){ eval_gr1 = String.valueOf(ht.get("EVAL_GR1"));	}
			  		if(eval_gr1.equals("") && String.valueOf(ht.get("EVAL_OFF2")).equals("크레탑")){ eval_gr1 = String.valueOf(ht.get("EVAL_GR2"));	}
			  		if(eval_gr1.equals("") && String.valueOf(ht.get("EVAL_OFF3")).equals("크레탑")){ eval_gr1 = String.valueOf(ht.get("EVAL_GR3"));	}
			  		if(eval_gr1.equals("") && String.valueOf(ht.get("EVAL_OFF4")).equals("크레탑")){ eval_gr1 = String.valueOf(ht.get("EVAL_GR4"));	}
			  		if(eval_gr1.equals("") && String.valueOf(ht.get("EVAL_OFF5")).equals("크레탑")){ eval_gr1 = String.valueOf(ht.get("EVAL_GR5"));	}
			  	%>
				<cell><![CDATA[<%=eval_gr1%>]]></cell>
				<%
			  		String eval_gr2 = "";
			  		if(eval_gr2.equals("") && String.valueOf(ht.get("EVAL_OFF1")).equals("NICE")){ eval_gr2 = String.valueOf(ht.get("EVAL_GR1"));	}
			  		if(eval_gr2.equals("") && String.valueOf(ht.get("EVAL_OFF2")).equals("NICE")){ eval_gr2 = String.valueOf(ht.get("EVAL_GR2"));	}
			  		if(eval_gr2.equals("") && String.valueOf(ht.get("EVAL_OFF3")).equals("NICE")){ eval_gr2 = String.valueOf(ht.get("EVAL_GR3"));	}
			  		if(eval_gr2.equals("") && String.valueOf(ht.get("EVAL_OFF4")).equals("NICE")){ eval_gr2 = String.valueOf(ht.get("EVAL_GR4"));	}
			  		if(eval_gr2.equals("") && String.valueOf(ht.get("EVAL_OFF5")).equals("NICE")){ eval_gr2 = String.valueOf(ht.get("EVAL_GR5"));	}
			  	%>
				<cell><![CDATA[<%=eval_gr2%>]]></cell>
				<%
			  		String eval_gr3 = "";
			  		if(eval_gr3.equals("") && String.valueOf(ht.get("EVAL_OFF1")).equals("KCB")){ eval_gr3 = String.valueOf(ht.get("EVAL_GR1"));	}
			  		if(eval_gr3.equals("") && String.valueOf(ht.get("EVAL_OFF2")).equals("KCB")){ eval_gr3 = String.valueOf(ht.get("EVAL_GR2"));	}
			  		if(eval_gr3.equals("") && String.valueOf(ht.get("EVAL_OFF3")).equals("KCB")){ eval_gr3 = String.valueOf(ht.get("EVAL_GR3"));	}
			  		if(eval_gr3.equals("") && String.valueOf(ht.get("EVAL_OFF4")).equals("KCB")){ eval_gr3 = String.valueOf(ht.get("EVAL_GR4"));	}
			  		if(eval_gr3.equals("") && String.valueOf(ht.get("EVAL_OFF5")).equals("KCB")){ eval_gr3 = String.valueOf(ht.get("EVAL_GR5"));	}
			  	%>
				<cell><![CDATA[<%=eval_gr3%>]]></cell>
				<cell><![CDATA[<%=ht.get("GUR_P_PER")%>]]></cell>
				<cell><![CDATA[<%=ht.get("PERE_R_PER")%>]]></cell>				
				<cell><![CDATA[<%=ht.get("IFEE_PER")%>]]></cell>
				<cell><![CDATA[<%=ht.get("GI_PER")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseFloat(String.valueOf(ht.get("GUR_P_PER")))+AddUtil.parseFloat(String.valueOf(ht.get("PERE_R_PER")))+AddUtil.parseFloat(String.valueOf(ht.get("IFEE_PER")))+AddUtil.parseFloat(String.valueOf(ht.get("GI_PER")))%>%]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(String.valueOf(ht.get("O_DLY_DAYS")))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(String.valueOf(ht.get("O_DLY_AMT")))%>]]></cell>				
				<cell><![CDATA[<%=AddUtil.parseDecimal(String.valueOf(ht.get("N_DLY_DAYS")))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(String.valueOf(ht.get("N_DLY_AMT")))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(String.valueOf(ht.get("T_FEE_AMT")))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(String.valueOf(ht.get("DLY_FEE_AMT")))%>]]></cell>
				<cell><![CDATA[<%=ht.get("DLY_PER")%>%]]></cell>
			</row>
<%}

}%>

</rows>	